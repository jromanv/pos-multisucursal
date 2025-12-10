const bcrypt = require('bcrypt');

const password = 'Admin123!';
const rounds = 10;

bcrypt.hash(password, rounds, (err, hash) => {
    if (err) {
        console.error('Error:', err);
    } else {
        console.log('Password:', password);
        console.log('Hash:', hash);
        console.log('\nCopia este hash y actualiza la base de datos');
    }
});