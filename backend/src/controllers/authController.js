const { pool } = require('../config/database');
const { compararPassword } = require('../utils/bcrypt');
const { generarAccessToken, generarRefreshToken, verificarRefreshToken } = require('../utils/jwt');

/**
 * Login de usuario
 */
const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validar datos requeridos
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email y contraseña son requeridos',
            });
        }

        // Buscar usuario por email
        const resultado = await pool.query(
            `SELECT u.*, s.nombre as sucursal_nombre 
       FROM usuarios u
       LEFT JOIN sucursales s ON u.sucursal_id = s.id
       WHERE u.email = $1`,
            [email.toLowerCase()]
        );

        if (resultado.rows.length === 0) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas',
            });
        }

        const usuario = resultado.rows[0];

        // Verificar que el usuario esté activo
        if (!usuario.activo) {
            return res.status(403).json({
                success: false,
                message: 'Usuario inactivo. Contacta al administrador',
            });
        }

        // Verificar password
        const passwordValido = await compararPassword(password, usuario.password_hash);

        if (!passwordValido) {
            return res.status(401).json({
                success: false,
                message: 'Credenciales inválidas',
            });
        }

        // Preparar payload para el token
        const payload = {
            id: usuario.id,
            email: usuario.email,
            rol: usuario.rol,
            sucursal_id: usuario.sucursal_id,
        };

        // Generar tokens
        const accessToken = generarAccessToken(payload);
        const refreshToken = generarRefreshToken(payload);

        // Actualizar último acceso
        await pool.query(
            'UPDATE usuarios SET ultimo_acceso = CURRENT_TIMESTAMP WHERE id = $1',
            [usuario.id]
        );

        // Registrar en auditoría
        await pool.query(
            `INSERT INTO auditoria (usuario_id, accion, tabla, ip, user_agent)
       VALUES ($1, $2, $3, $4, $5)`,
            [
                usuario.id,
                'login',
                'usuarios',
                req.ip,
                req.get('user-agent'),
            ]
        );

        // Responder con datos del usuario y tokens
        res.json({
            success: true,
            message: 'Login exitoso',
            data: {
                usuario: {
                    id: usuario.id,
                    nombre: usuario.nombre,
                    apellido: usuario.apellido,
                    email: usuario.email,
                    rol: usuario.rol,
                    sucursal_id: usuario.sucursal_id,
                    sucursal_nombre: usuario.sucursal_nombre,
                },
                accessToken,
                refreshToken,
            },
        });
    } catch (error) {
        console.error('Error en login:', error);
        res.status(500).json({
            success: false,
            message: 'Error al iniciar sesión',
            error: error.message,
        });
    }
};

/**
 * Renovar Access Token usando Refresh Token
 */
const refreshAccessToken = async (req, res) => {
    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(400).json({
                success: false,
                message: 'Refresh token requerido',
            });
        }

        // Verificar refresh token
        const decoded = verificarRefreshToken(refreshToken);

        // Verificar que el usuario existe y está activo
        const resultado = await pool.query(
            'SELECT id, email, rol, sucursal_id, activo FROM usuarios WHERE id = $1',
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

        // Generar nuevo access token
        const payload = {
            id: usuario.id,
            email: usuario.email,
            rol: usuario.rol,
            sucursal_id: usuario.sucursal_id,
        };

        const nuevoAccessToken = generarAccessToken(payload);

        res.json({
            success: true,
            message: 'Token renovado exitosamente',
            data: {
                accessToken: nuevoAccessToken,
            },
        });
    } catch (error) {
        if (error.message === 'Refresh token inválido o expirado') {
            return res.status(401).json({
                success: false,
                message: 'Refresh token inválido o expirado',
            });
        }

        console.error('Error al renovar token:', error);
        res.status(500).json({
            success: false,
            message: 'Error al renovar token',
            error: error.message,
        });
    }
};

/**
 * Obtener información del usuario actual
 */
const obtenerPerfil = async (req, res) => {
    try {
        const resultado = await pool.query(
            `SELECT u.id, u.nombre, u.apellido, u.email, u.telefono, u.rol, 
              u.sucursal_id, s.nombre as sucursal_nombre, u.ultimo_acceso
       FROM usuarios u
       LEFT JOIN sucursales s ON u.sucursal_id = s.id
       WHERE u.id = $1`,
            [req.usuario.id]
        );

        if (resultado.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Usuario no encontrado',
            });
        }

        res.json({
            success: true,
            data: resultado.rows[0],
        });
    } catch (error) {
        console.error('Error al obtener perfil:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener perfil',
            error: error.message,
        });
    }
};

/**
 * Logout (opcional - para invalidar tokens en el cliente)
 */
const logout = async (req, res) => {
    try {
        // Registrar en auditoría
        await pool.query(
            `INSERT INTO auditoria (usuario_id, accion, tabla, ip, user_agent)
       VALUES ($1, $2, $3, $4, $5)`,
            [
                req.usuario.id,
                'logout',
                'usuarios',
                req.ip,
                req.get('user-agent'),
            ]
        );

        res.json({
            success: true,
            message: 'Logout exitoso',
        });
    } catch (error) {
        console.error('Error en logout:', error);
        res.status(500).json({
            success: false,
            message: 'Error al cerrar sesión',
            error: error.message,
        });
    }
};

module.exports = {
    login,
    refreshAccessToken,
    obtenerPerfil,
    logout,
};