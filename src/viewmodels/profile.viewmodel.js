// src/viewmodels/profile.viewmodel.js
const { PrismaClient } = require('@prisma/client');
const { deleteDocument } = require('../controllers/user.controller');
const prisma = new PrismaClient();

class UserProfileViewModel {
  async basicprofile(userId, fullname, phnumber, avatarId) {
    console.log(avatarId);
    console.log("==============");
    console.log(userId);
  
    const userExists = await prisma.profile.findUnique({ where: { userId } });
  
    if (userExists) {
      // Update the existing user profile
      const updatedUser = await prisma.profile.update({
        where: { userId },
        data: {
          fullname,
          phnumber,
          avatarId, // Update avatarId if necessary
        },
      });
      return updatedUser;
    } else {
      // Create a new profile if the user doesn't exist
      const newUser = await prisma.profile.create({
        data: {
          userId,
          avatarId,
          fullname,
          phnumber,
        },
      });
      return newUser;
    }
  }
  

  async getProfile(userId) {
    try {
      const userDetails = await prisma.user.findUnique({
        where: { id: userId },
        include: {
          Profile: {
            include: {
              JobSeekerProfile: true,  // Fetch Job Seeker Profile details
              MentorProfile: true,     // Fetch Mentor Profile details
              RecruiterProfile: true,  // Fetch Recruiter Profile details
              EmployerProfile: true,   // Fetch Employer Profile details
              AdminProfile: true       // Fetch Admin Profile details
            },
          },
          Education: true,            // Fetch all Education details
          Certificate: true,          // Fetch all Certificate details
          Location: true,             // Fetch all Location details
          EmpolymentHistory: true,    // Fetch all Employment History
          Documents: true             // Fetch all Documents details
        }
      });
  
      // If no user found, return null or handle as needed
      if (!userDetails) {
        throw new Error('User not found');
      }
  
      // Base URLs for avatar and documents
      const avatarBaseUrl = "http://your-server-url/utils/profilephotos"; // Replace with your actual URL
      const resumeBaseUrl = "http://your-server-url/utils/resume";         // Replace with your actual URL
  
      // Add full URL for avatar
      userDetails.Profile.forEach(profile => {
        if (profile.avatarId) {
          profile.avatarUrl = `${avatarBaseUrl}/${profile.avatarId}`;
        }
      });
  
      // Add full URL for resume and portfolio documents
      userDetails.Documents.forEach(document => {
        if (document.resumeLink) {
          document.resumeUrl = `${resumeBaseUrl}/${document.resumeLink}`;
        }
        if (document.portfolioLink) {
          document.portfolioUrl = `${resumeBaseUrl}/${document.portfolioLink}`;
        }
      });
  
      // Remove password field
      delete userDetails.password;
  
      return userDetails;
    } catch (error) {
      throw new Error('Error fetching user details: ' + error.message);
    }
  }
  
  
  

  async deleteProfile(userId) {
    const userProfile = await prisma.profile.findUnique({
      where: { userId }
    });
  
    if (!userProfile) {
      throw new Error('Profile not found');
    }
  
    // Perform the deletion
    const deletedProfile = await prisma.profile.delete({
      where: { userId }
    });
  
    return deletedProfile;
  }

  async insertEducation(degree, institution, description, from, to, userId) {
    // Convert Date objects to ISO string format
    const fromDate = new Date(from).toISOString(); // Convert to ISO 8601 string
    const toDate = new Date(to).toISOString(); // Convert to ISO 8601 string
  
    // Use upsert to either update an existing record or create a new one
    const updatedEducation = await prisma.education.upsert({
      where: { userId }, // Match by userId
      update: {
        degreName: degree, // Corrected field name
        universityName: institution,
        description,
        startFrom: fromDate, // Use ISO 8601 string
        endIn: toDate, // Use ISO 8601 string
      },
      create: {
        degreName: degree, // Corrected field name
        universityName: institution,
        description,
        startFrom: fromDate, // Use ISO 8601 string
        endIn: toDate, // Use ISO 8601 string
        userId: userId,
      },
    });
  
    return updatedEducation;
  }

  async deleteEducation(userId) {
    const userProfile = await prisma.education.findUnique({
      where: { userId }
    });
  
    if (!userProfile) {
      throw new Error('Education for this user not exists');
    }
  
    // Perform the deletion
    const deletedProfile = await prisma.education.delete({
      where: { userId }
    });
  
    return deletedProfile;
  }

  async insertCertificate(certName, orgName, description, from, to, userId) {
    // Convert date strings to ISO 8601 format (if not already)
    const fromDate = new Date(from).toISOString();
    const toDate = new Date(to).toISOString();
  
    // Use upsert to either update the existing certificate or insert a new one
    const updatedCertificate = await prisma.certificate.upsert({
      where: { userId }, // Match by userId to ensure uniqueness
      update: {
        certName: certName,
        orgName: orgName,
        startedOn:fromDate,
        completedOn: toDate, // Assume `completedOn` is the "to" date
      },
      create: {
        certName: certName,
        orgName: orgName,
        startedOn:fromDate,
        completedOn: toDate,
        userId: userId,
      },
    });
  
    return updatedCertificate;
  }

  async  deleteCertificate(userId) {
    // Check if a certificate exists for the user
    const certificate = await prisma.certificate.findUnique({
      where: { userId }
    });
  
    if (!certificate) {
      throw new Error('Certificate for this user does not exist');
    }
  
    // Perform the deletion
    const deletedCertificate = await prisma.certificate.delete({
      where: { userId }
    });
  
    return deletedCertificate;
  } 

  async addLocation(userId, city, state, country, postalCode) {
    try {
      // Check if a location already exists for this user
      const existingLocation = await prisma.location.findFirst({
        where: { userId }
      });
  
      if (existingLocation) {
        // Update the existing location
        const updatedLocation = await prisma.location.update({
          where: { id: existingLocation.id }, // Use the unique 'id' field to update
          data: {
            city,
            state,
            country,
            postalCode,
          },
        });
        return updatedLocation;
      } else {
        // Create a new location
        const newLocation = await prisma.location.create({
          data: {
            userId,
            city,
            state,
            country,
            postalCode,
          },
        });
        return newLocation;
      }
    } catch (error) {
      throw new Error('Error adding or updating location: ' + error.message);
    }
  }
  
  
  
  // ViewModel for deleting a location by ID
  async deleteLocation(userId) {
    try {
      // Check if the location exists for the given userId
      const location = await prisma.location.findFirst({
        where: { userId }
      });
  
      if (!location) {
        throw new Error('Location for this user does not exist');
      }
  
      // Proceed to delete the found location
      const deletedLocation = await prisma.location.delete({
        where: { id: location.id }, // Use the unique identifier of the found location
      });
  
      return deletedLocation;
    } catch (error) {
      throw new Error('Error deleting location: ' + error.message);
    }
  }
  
  
  // ViewModel for getting locations by userId
  async getLocations (userId){
    try {
      const locations = await prisma.location.findMany({
        where: { userId },
      });
      return locations;
    } catch (error) {
      throw new Error('Error retrieving locations: ' + error.message);
    }
  };


  async InsertDocuments(userId, resumePath, portfolioPath, websiteLink, additionalLink) {
    try {
      // Check if a document record already exists for this user
      const existingDocument = await prisma.documents.findFirst({
        where: { userId }
      });
  
      if (existingDocument) {
        console.log("data updated");
        // Update the existing document
        const updatedDocument = await prisma.documents.update({
          where: { id: existingDocument.id }, // Use the unique 'id' field to update
          data: {
            resumeLink: resumePath,
            portfolioLink: portfolioPath,
            websiteLink: websiteLink || existingDocument.websiteLink, // Optional update
            additionalLink: additionalLink || existingDocument.additionLink, // Optional update
          },
        });
        return updatedDocument;
      } else {
        console.log("data inserted");
        // Create a new document record
        const newDocument = await prisma.documents.create({
          data: {
            userId,
            resumeLink: resumePath,
            portfolioLink: portfolioPath,
            websiteLink, // Nullable, can be undefined
            additionalLink, // Nullable, can be undefined
          },
        });
        return newDocument;
      }
    } catch (error) {
      throw new Error('Error inserting or updating documents: ' + error.message);
    }
  }


    
  async  upsertEmploymentHistory(company, jobTitle, description, startedOn, endOn, userId) {
  
    const result = await prisma.EmpolymentHistory.upsert({
      where: { userId }, 
      update: {
        company,
        jobTitle,
        description,
        startedOn: new Date(startedOn).toISOString(), 
        endOn: new Date(endOn).toISOString(),
      },
      create: {
        company,
        jobTitle,
        description,
        startedOn: new Date(startedOn).toISOString(),
        endOn: new Date(endOn).toISOString(),
        userId,
      },
    });
    return result;
  }
 
  async deleteEmploymentHistory(userId) {
    // Check if the employment history exists for the given userId
    const employmentHistory = await prisma.EmpolymentHistory.findFirst({
      where: { userId }
    });
  
    if (!employmentHistory) {
      throw new Error('Employment history for this user does not exist');
    }
  
    // Now delete the found record using its unique ID
    const deletedEmploymentHistory = await prisma.EmpolymentHistory.delete({
      where: { id: employmentHistory.id } // Use the unique ID of the record
    });
  
    return deletedEmploymentHistory;
  }
  


async getEmploymentHistory(userId) {
  const result = await prisma.employmentHistory.findUnique({
    where: { userId },
  });
  return result;
}
  

async deleteDocument(userId) {
  // Check if the document exists for the given userId
  const document = await prisma.documents.findFirst({
    where: { userId }
  });

  if (!document) {
    throw new Error('Document for this user does not exist');
  }

  // Now delete the found document using its unique ID
  const deletedDocument = await prisma.documents.delete({
    where: { id: document.id } // Use the unique ID of the document
  });

  return deletedDocument;
}



}

module.exports = new UserProfileViewModel();
