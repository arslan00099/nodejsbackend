/*
  Warnings:

  - You are about to drop the column `revenueId` on the `MentorProfile` table. All the data in the column will be lost.
  - You are about to drop the column `revenueId` on the `RecruiterProfile` table. All the data in the column will be lost.
  - You are about to drop the column `username` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `Revenue` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `linkedinProfile` to the `MentorProfile` table without a default value. This is not possible if the table is not empty.
  - Added the required column `linkedinProfile` to the `RecruiterProfile` table without a default value. This is not possible if the table is not empty.
  - Made the column `role` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
-- DropForeignKey
ALTER TABLE `MentorProfile` DROP FOREIGN KEY `MentorProfile_revenueId_fkey`;

-- DropForeignKey
ALTER TABLE `RecruiterProfile` DROP FOREIGN KEY `RecruiterProfile_revenueId_fkey`;

-- AlterTable
ALTER TABLE `EmployerProfile` ADD COLUMN `resume` VARCHAR(191) NULL;

-- AlterTable
ALTER TABLE `MentorProfile` DROP COLUMN `revenueId`,
    ADD COLUMN `linkedinProfile` VARCHAR(191) NOT NULL,
    ADD COLUMN `resume` VARCHAR(191) NULL;

-- AlterTable
ALTER TABLE `RecruiterProfile` DROP COLUMN `revenueId`,
    ADD COLUMN `linkedinProfile` VARCHAR(191) NOT NULL,
    ADD COLUMN `resume` VARCHAR(191) NULL;

-- AlterTable
ALTER TABLE `User` DROP COLUMN `username`,
    ADD COLUMN `name` VARCHAR(191) NULL,
    MODIFY `role` ENUM('JOB_SEEKER', 'MENTOR', 'RECRUITER', 'EMPLOYER', 'ADMIN') NOT NULL;

-- DropTable
DROP TABLE `Revenue`;

-- CreateTable
CREATE TABLE `Education` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `degreName` VARCHAR(191) NOT NULL,
    `universityName` VARCHAR(191) NOT NULL,
    `startFrom` VARCHAR(191) NOT NULL,
    `endIn` VARCHAR(191) NOT NULL,
    `userId` INTEGER NOT NULL,

    UNIQUE INDEX `Education_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Certificate` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `certName` VARCHAR(191) NOT NULL,
    `orgName` VARCHAR(191) NOT NULL,
    `completedOn` VARCHAR(191) NOT NULL,
    `userId` INTEGER NOT NULL,

    UNIQUE INDEX `Certificate_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AdminProfile` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `profileId` INTEGER NOT NULL,

    UNIQUE INDEX `AdminProfile_profileId_key`(`profileId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `JobApplication` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `jobTitle` VARCHAR(191) NOT NULL,
    `jobDescription` VARCHAR(191) NOT NULL,
    `tags` VARCHAR(191) NOT NULL,
    `jsId` INTEGER NOT NULL,
    `postedBy` INTEGER NOT NULL,
    `jobStatus` ENUM('OPEN', 'HIRED', 'CLOSED', 'CANCELLED', 'ONHOLD') NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `jobPostId` INTEGER NULL,

    INDEX `JobApplication_tags_idx`(`tags`),
    INDEX `JobApplication_jobTitle_idx`(`jobTitle`),
    INDEX `JobApplication_jsId_idx`(`jsId`),
    INDEX `JobApplication_postedBy_idx`(`postedBy`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Service` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `mentorProfileId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MentorSessionManagement` (
    `sessionId` INTEGER NOT NULL AUTO_INCREMENT,
    `agenda` VARCHAR(191) NOT NULL,
    `selectedService` VARCHAR(191) NOT NULL,
    `time` DATETIME(3) NOT NULL,
    `price` INTEGER NOT NULL,
    `status` ENUM('ACCEPTED', 'DECLINED', 'CANCELLED', 'WAITING') NOT NULL,
    `jsId` INTEGER NOT NULL,
    `mentorId` INTEGER NOT NULL,
    `paymentStatus` ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED') NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`sessionId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `JobPost` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `location` VARCHAR(191) NOT NULL,
    `applicationLink` VARCHAR(191) NOT NULL,
    `employerId` INTEGER NOT NULL,
    `status` ENUM('OPEN', 'HIRED', 'CLOSED', 'CANCELLED', 'ONHOLD') NOT NULL DEFAULT 'OPEN',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RecruiterHiring` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `employerId` INTEGER NOT NULL,
    `serviceId` INTEGER NOT NULL,
    `recruiterId` INTEGER NOT NULL,
    `status` ENUM('ACCEPTED', 'DECLINED', 'CANCELLED') NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TimeSheet` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `employerId` INTEGER NOT NULL,
    `recruiterId` INTEGER NOT NULL,
    `fuseAdminId` INTEGER NULL,
    `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Blog` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(191) NOT NULL,
    `content` VARCHAR(191) NOT NULL,
    `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    `mentorId` INTEGER NOT NULL,
    `fuseAdminId` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Booking` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `date` DATETIME(3) NOT NULL,
    `duration` INTEGER NOT NULL,
    `mentorId` INTEGER NULL,
    `recruiterId` INTEGER NULL,
    `status` ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Earning` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `amount` DOUBLE NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `mentorId` INTEGER NULL,
    `recruiterId` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE INDEX `User_role_idx` ON `User`(`role`);

-- AddForeignKey
ALTER TABLE `Education` ADD CONSTRAINT `Education_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Certificate` ADD CONSTRAINT `Certificate_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AdminProfile` ADD CONSTRAINT `AdminProfile_profileId_fkey` FOREIGN KEY (`profileId`) REFERENCES `Profile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JobApplication` ADD CONSTRAINT `JobApplication_jsId_fkey` FOREIGN KEY (`jsId`) REFERENCES `JobSeekerProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JobApplication` ADD CONSTRAINT `JobApplication_postedBy_fkey` FOREIGN KEY (`postedBy`) REFERENCES `EmployerProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JobApplication` ADD CONSTRAINT `JobApplication_jobPostId_fkey` FOREIGN KEY (`jobPostId`) REFERENCES `JobPost`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Service` ADD CONSTRAINT `Service_mentorProfileId_fkey` FOREIGN KEY (`mentorProfileId`) REFERENCES `MentorProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MentorSessionManagement` ADD CONSTRAINT `MentorSessionManagement_jsId_fkey` FOREIGN KEY (`jsId`) REFERENCES `JobSeekerProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MentorSessionManagement` ADD CONSTRAINT `MentorSessionManagement_mentorId_fkey` FOREIGN KEY (`mentorId`) REFERENCES `MentorProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `JobPost` ADD CONSTRAINT `JobPost_employerId_fkey` FOREIGN KEY (`employerId`) REFERENCES `EmployerProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RecruiterHiring` ADD CONSTRAINT `RecruiterHiring_serviceId_fkey` FOREIGN KEY (`serviceId`) REFERENCES `Service`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RecruiterHiring` ADD CONSTRAINT `RecruiterHiring_employerId_fkey` FOREIGN KEY (`employerId`) REFERENCES `EmployerProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RecruiterHiring` ADD CONSTRAINT `RecruiterHiring_recruiterId_fkey` FOREIGN KEY (`recruiterId`) REFERENCES `RecruiterProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TimeSheet` ADD CONSTRAINT `TimeSheet_employerId_fkey` FOREIGN KEY (`employerId`) REFERENCES `EmployerProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TimeSheet` ADD CONSTRAINT `TimeSheet_recruiterId_fkey` FOREIGN KEY (`recruiterId`) REFERENCES `RecruiterProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TimeSheet` ADD CONSTRAINT `TimeSheet_fuseAdminId_fkey` FOREIGN KEY (`fuseAdminId`) REFERENCES `AdminProfile`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Blog` ADD CONSTRAINT `Blog_mentorId_fkey` FOREIGN KEY (`mentorId`) REFERENCES `MentorProfile`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Blog` ADD CONSTRAINT `Blog_fuseAdminId_fkey` FOREIGN KEY (`fuseAdminId`) REFERENCES `AdminProfile`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Booking` ADD CONSTRAINT `Booking_mentorId_fkey` FOREIGN KEY (`mentorId`) REFERENCES `MentorProfile`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Booking` ADD CONSTRAINT `Booking_recruiterId_fkey` FOREIGN KEY (`recruiterId`) REFERENCES `RecruiterProfile`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Earning` ADD CONSTRAINT `Earning_mentorId_fkey` FOREIGN KEY (`mentorId`) REFERENCES `MentorProfile`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Earning` ADD CONSTRAINT `Earning_recruiterId_fkey` FOREIGN KEY (`recruiterId`) REFERENCES `RecruiterProfile`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
