const { verificarAccessToken } = require('../utils/jwt');
const { pool } = require('../config/database');

/**
 * Middleware para verificar autenticación
 */
const verificarAutenticacion = async (req, res, next) => {
    try {
        // Obtener token del header
        const authHeader = req.headers.authorization;

        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({
                success: false,
                message: 'Token no proporcionado',
            });
        }

        const token = authHeader.substring(7); // Remover "Bearer "

        // Verificar token
        const decoded = verificarAccessToken(token);

        // Verificar que el usuario existe y está activo
        const resultado = await pool.query(
            'SELECT id, nombre, apellido, email, rol, sucursal_id, activo FROM usuarios WHERE id = $1',
            [decoded.id]
        );

        if (resultado.rows.length === 0) {
            return res.status(401).json({
                success: false,
                message: 'Usuario no encontrado',
            });
        }

        const usuario = resultado.rows[0];

        if (!usuario.activo) {
            return res.status(403).json({
                success: false,
                message: 'Usuario inactivo',
            });
        }

        // Agregar usuario al request
        req.usuario = usuario;

        next();
    } catch (error) {
        if (error.message === 'Token inválido o expirado') {
            return res.status(401).json({
                success: false,
                message: 'Token inválido o expirado',
            });
        }

        return res.status(500).json({
            success: false,
            message: 'Error al verificar autenticación',
            error: error.message,
        });
    }
};

/**
 * Middleware para verificar roles
 */
const verificarRoles = (...rolesPermitidos) => {
    return (req, res, next) => {
        if (!req.usuario) {
            return res.status(401).json({
                success: false,
                message: 'Usuario no autenticado',
            });
        }

        if (!rolesPermitidos.includes(req.usuario.rol)) {
            return res.status(403).json({
                success: false,
                message: 'No tienes permisos para acceder a este recurso',
                rolRequerido: rolesPermitidos,
                rolActual: req.usuario.rol,
            });
        }

        next();
    };
};

/**
 * Middleware para verificar que el usuario pertenece a una sucursal
 */
const verificarSucursal = (req, res, next) => {
    if (!req.usuario) {
        return res.status(401).json({
            success: false,
            message: 'Usuario no autenticado',
        });
    }

    // Administrador y propietario pueden acceder a todas las sucursales
    if (['administrador', 'propietario'].includes(req.usuario.rol)) {
        return next();
    }

    // Vendedor debe tener sucursal asignada
    if (!req.usuario.sucursal_id) {
        return res.status(403).json({
            success: false,
            message: 'Usuario sin sucursal asignada',
        });
    }

    next();
};

module.exports = {
    verificarAutenticacion,
    verificarRoles,
    verificarSucursal,
};