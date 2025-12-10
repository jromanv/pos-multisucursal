const bcrypt = require('bcrypt');

/**
 * Hashear password
 */
const hashPassword = async (password) => {
    const rounds = parseInt(process.env.BCRYPT_ROUNDS) || 10;
    return await bcrypt.hash(password, rounds);
};

/**
 * Comparar password
 */
const compararPassword = async (password, hash) => {
    return await bcrypt.compare(password, hash);
};

module.exports = {
    hashPassword,
    compararPassword,
};