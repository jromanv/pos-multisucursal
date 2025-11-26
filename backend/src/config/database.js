const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    max: 20, // Máximo de conexiones en el pool
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

// Verificar conexión
pool.on('connect', () => {
    console.log('Conectado a PostgreSQL');
});

pool.on('error', (err) => {
    console.error('Error inesperado en PostgreSQL:', err);
    process.exit(-1);
});

// Función para probar la conexión
const testConnection = async () => {
    try {
        const result = await pool.query('SELECT NOW()');
        console.log('🔌 Conexión a BD exitosa:', result.rows[0].now);
        return true;
    } catch (error) {
        console.error('Error al conectar a la BD:', error.message);
        return false;
    }
};

module.exports = {
    pool,
    testConnection,
};