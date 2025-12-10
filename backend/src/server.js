const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const { testConnection } = require('./config/database');

const app = express();
const PORT = process.env.PORT || 5000;

// ===== MIDDLEWARES DE SEGURIDAD =====
app.use(helmet()); // Headers de seguridad

// Rate Limiting - Prevenir ataques de fuerza bruta
const limiter = rateLimit({
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutos
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100, // límite de requests
    message: 'Demasiadas peticiones desde esta IP, intenta de nuevo más tarde.',
    standardHeaders: true,
    legacyHeaders: false,
});

app.use('/api', limiter);

// ===== MIDDLEWARES GENERALES =====
app.use(cors({
    origin: process.env.NODE_ENV === 'production'
        ? ['https://tu-dominio.com']
        : [
            'http://localhost:3000',
            'http://127.0.0.1:3000',
            'http://192.168.31.14:3000', // Tu IP local
        ],
    credentials: true,
}));

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(morgan('dev')); // Logs de peticiones HTTP

// ===== RUTAS =====
const authRoutes = require('./routes/authRoutes');
app.use('/api/auth', authRoutes);

// ===== RUTA DE PRUEBA =====
app.get('/api/health', (req, res) => {
    res.json({
        success: true,
        message: '🚀 Servidor funcionando correctamente',
        timestamp: new Date().toISOString(),
    });
});

// ===== MANEJO DE RUTAS NO ENCONTRADAS =====
app.use((req, res) => {
    res.status(404).json({
        success: false,
        message: 'Ruta no encontrada',
    });
});

// ===== MANEJO DE ERRORES GLOBAL =====
app.use((err, req, res, next) => {
    console.error('❌ Error:', err.stack);
    res.status(err.status || 500).json({
        success: false,
        message: err.message || 'Error interno del servidor',
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
    });
});

// ===== INICIAR SERVIDOR =====
const startServer = async () => {
    try {
        // Probar conexión a la base de datos
        const dbConnected = await testConnection();

        if (!dbConnected) {
            console.error('No se pudo conectar a la base de datos');
            process.exit(1);
        }

        // Iniciar servidor
        app.listen(PORT, () => {
            console.log('=================================');
            console.log(`Servidor corriendo en puerto ${PORT}`);
            console.log(`Entorno: ${process.env.NODE_ENV}`);
            console.log(`API disponible en: http://localhost:${PORT}/api`);
            console.log('=================================');
        });
    } catch (error) {
        console.error('Error al iniciar servidor:', error);
        process.exit(1);
    }
};

startServer();

module.exports = app;