const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  const token = req.header('Authorization');
  if (!token) {
    return res.status(401).json({ success: false, message: 'No token provided' });
  }

  try {
    // Verify the JWT token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Extract the id and role from the decoded token
    const { userId, role } = decoded;

    // Add the user information to the request object
    req.user = { userId, role };

    next();
  } catch (err) {
    res.status(401).json({ success: false, message: 'Invalid token' });
  }
};
