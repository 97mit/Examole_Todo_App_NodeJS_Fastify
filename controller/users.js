let response = require('../response');
let connection = require('../connection');
let sha1 = require('sha1');
let crypto = require('crypto');

async function register(request, reply) {
    let reqData = JSON.parse(request.body.data);
   // console.log(request.file.path)
    reqData["avatar"] = request.file.path;
    reqData["password"] = sha1(reqData.password);
    reqData["token"] = crypto.randomBytes(32).toString('hex');
    let sql = `CALL USP_TBL_M_USER_REGISTER(?);`;
// Use a promise if you need data to be returned after the callback
    let data = await new Promise((resolve) =>
        connection.query(sql,
            [JSON.stringify(reqData)], function (error, rows) {
                if(error){
                    // Check in advance for existing data.
                    if(error.code === 'ER_DUP_ENTRY'){
                        return response.badRequest('', `E-mail ${reqData.email} has been used!`, reply)
                    }
                    // If it is not a duplicate entry, then an error print will occur.
                    return response.badRequest('', `${error}`, reply)
                }
                return resolve({ name: reqData.name, email: reqData.email, token :  reqData.token,avatar:reqData.avatar});
            })
    );
    return response.ok(data , `Successful new user registration - ${reqData.email}`, reply);
}
async function login(request, reply) {

    let email = request.body.email;
    let password = request.body.password;
    let sql = `SELECT * FROM users WHERE email = ?`;

    let data = await new Promise((resolve) =>
        connection.query(sql, [email], function (error, rows) {
            if(error){
                console.log(error);
                return response.badRequest('', `${error}`, reply)
            }

            if(rows.length > 0){
                let verify = sha1(password) === rows[0].password;

                let data = {
                    name: rows[0].name,
                    email: rows[0].email,
                    token: rows[0].remember_token
                };

                return verify ? resolve(data) : resolve(false);
            }
            else{
                return resolve(false);
            }
        })
    );

    if(!data){
        return response.badRequest('','The email or password you entered is incorrect!', reply)
    }

    return response.ok(data, `Successfully logged in!`, reply);
}
module.exports = {
    register,login
};
