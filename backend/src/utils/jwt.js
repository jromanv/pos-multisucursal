const jwt = require('jsonwebtoken');

/**
 * Generar Access Token
 */
const generarAccessToken = (payload) => {
    return jwt.sign(payload, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN || '24h',
    });
};

/**
 * Generar Refresh Token
 */
const generarRefreshToken = (payload) => {
    return jwt.sign(payload, process.env.JWT_REFRESH_SECRET, {
        expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
    });
};

/**
 * Verificar Access Token
 */
const verificarAccessToken = (token) => {
    try {
        return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
        throw new Error('Token inválido o expirado');
    }
};

/**
 * Verificar Refresh Token
 */
const verificarRefreshToken = (token) => {
    try {
        return jwt.verify(token, process.env.JWT_REFRESH_SECRET);
    } catch (error) {
        throw new Error('Refresh token inválido o expirado');
    }
};

module.exports = {
    generarAccessToken,
    generarRefreshToken,
    verificarAccessToken,
    verificarRefreshToken,
};