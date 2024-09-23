// src/routes/auth.routes.js

const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller'); // Import controller, no view model here

router.post('/signup', authController.signup);
router.post('/login', authController.login);

module.exports = router;

