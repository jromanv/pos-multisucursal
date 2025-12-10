const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { verificarAutenticacion } = require('../middlewares/auth');

/**
 * @route   POST /api/auth/login
 * @desc    Login de usuario
 * @access  Public
 */
router.post('/login', authController.login);

/**
 * @route   POST /api/auth/refresh
 * @desc    Renovar access token
 * @access  Public
 */
router.post('/refresh', authController.refreshAccessToken);

/**
 * @route   GET /api/auth/perfil
 * @desc    Obtener perfil del usuario actual
 * @access  Private
 */
router.get('/perfil', verificarAutenticacion, authController.obtenerPerfil);

/**
 * @route   POST /api/auth/logout
 * @desc    Cerrar sesión
 * @access  Private
 */
router.post('/logout', verificarAutenticacion, authController.logout);

module.exports = router;