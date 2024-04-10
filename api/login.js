require('dotenv').config();
const { exec } = require('child_process');

const command = `aws cognito-idp initiate-auth --auth-flow USER_PASSWORD_AUTH --auth-parameters USERNAME=${process.env.BOOK_STORE_USER_NAME},PASSWORD=${process.env.PASSWORD} --client-id ${process.env.CLIENT_ID}`;

exec(command, (error, stdout, stderr) => {
    if (error) {
        console.log(`error: ${error.message}`);
        return;
    }
    if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
    }
    console.log(`stdout: ${stdout}`);
});