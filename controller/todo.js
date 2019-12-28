
let response = require('../response');
let connection = require('../connection');
let moment = require('moment');
let header = require('../helper/token');
var path = require('path');
const fastify = require('fastify')()
const concat = require('concat-stream')
const fs = require('fs')
const pump = require('pump')

//fastify.register(require('fastify-multipart'))
/*
async function get(request, reply) {
    let token = request.headers.authorization;
    let check = await header.check(token, reply);
    //let sql = `SELECT * FROM todo WHERE user_id = ?`;
    let sql = `call fastify.USP_GET_TODO();`;

    let data = await new Promise((resolve) => connection.query(sql, [check.user_id], function (error, rows) {
            if(error){
                console.log(error);
                return response.badRequest('', `${error}`, reply)
            }

            if(rows.length > 0){
                let array = [];
                rows.forEach(element => {
                    array.push({
                        id: element.id,
                        title: element.title,
                        description: element.description,
                        created_at: moment(element.created_at).format('YYYY-MM-DD HH:mm:ss').toString()
                    });
                });

                return resolve(array);
            }
            else{
                return resolve([]);
            }
        })
    );

    return response.ok(data, 'get', reply);
}
*/

async function get(request, reply) {
    console.log( "req =====:"+JSON.stringify(request.body));
    let token = request.headers.authorization;
    let reqData = JSON.parse(request.body.data);


    let check = await header.check(token, reply);
    reqData["user_id"] = check.user_id;
    //let sql = `SELECT * FROM todo WHERE user_id = ?`;
    let sql = `CALL USP_GET_TODO(?);`;
    let data = await new Promise((resolve) => connection.query(sql, [JSON.stringify(reqData)], function (error, rows) {
            if(error){
                return response.badRequest('', `${error}`, reply)
            }
            if(rows.length > 0){
                return resolve(rows[0]);
            }
            else{
                return resolve([]);
            }
        })
    );
    return response.ok(data, 'get', reply);
}
async function show(request, reply) {
    let reqData = JSON.parse(request.body.data);
    let token = request.headers.authorization;
    let check = await header.check(token, reply);
    reqData["user_id"] = check.user_id;
    let sql = `CALL USP_SHOW_TODO(?);`;
    let data = await new Promise((resolve) =>
        connection.query(sql,
            [JSON.stringify(reqData)], function (error, rows) {
                if(error){
                    console.log(error);
                    return response.badRequest('', `${error}`, reply)
                }
                return rows.length > 0 ? resolve(rows[0]) : resolve({});
            })
    );
    return response.ok(data, 'show', reply);
}

async function storeTodoImage(request, reply) {
    let reqData = JSON.parse(request.body.data);
    let now = moment().format('YYYY-MM-DD HH:mm:ss').toString();
    let token = request.headers.authorization;
    let check = await header.check(token, reply);
    reqData["user_id"] = check.user_id;
    reqData["created_at"] = now;
    reqData["updated_at"] = now;
    const mp = req.multipart(handler, function (err) {
        console.log('upload completed')
        reply.code(200).send({"ggg":200})
    })
    return response.ok({}, msg, reply);
}

async function store(request, reply) {
    let reqData = JSON.parse(request.body.data);
    let now = moment().format('YYYY-MM-DD HH:mm:ss').toString();
    let token = request.headers.authorization;
    let check = await header.check(token, reply);
    reqData["user_id"] = check.user_id;
    reqData["created_at"] = now;
    reqData["updated_at"] = now;
    let sql = `CALL USP_INSERT_TODO(?);`;
    let data = await new Promise((resolve) =>
        connection.query(sql,
            [JSON.stringify(reqData)], function (error, rows) {
                if(error){
                    console.log(error);
                    return response.badRequest('', `${error}`, reply)
                }
                return rows.affectedRows > 0 ? resolve(true) : resolve(false);
            })
    );
    let msg = data ? "Successfully added data!" : "Unable to add data!";
    return response.ok({}, msg, reply);
}

async function update(request, reply) {
    let reqData = JSON.parse(request.body.data);
    let token = request.headers.authorization;
    let check = await header.check(token, reply);
    reqData["user_id"] = check.user_id;
    let sql = `CALL USP_UPDATE_TODO(?);`;
    let data = await new Promise((resolve) =>
        connection.query(sql,
            [JSON.stringify(reqData)], function (error, rows) {
                if(error){
                    console.log(error);
                    return response.badRequest('', `${error}`, reply)
                }
                return rows.affectedRows > 0 ? resolve(true) : resolve(false);
            })
    );
    let msg = data ? "Successfully updated data!" : "Unable to update data!";
    return response.ok(data, msg, reply);
}

async function destroy(request, reply) {
    let reqData = JSON.parse(request.body.data);
    let token = request.headers.authorization;
    let check = await header.check(token, reply);
    reqData["user_id"] = check.user_id;
    let sql = `CALL USP_DELETE_TODO(?);`;

    let data = await new Promise((resolve) =>
        connection.query(sql,
            [JSON.stringify(reqData)], function (error, rows) {
                if(error){
                    console.log(error);
                    return response.badRequest('', `${error}`, reply)
                }

                return rows.affectedRows > 0 ? resolve(true) : resolve(false);
            })
    );

    let msg = data ? "Successfully deleted data!" : "Unable to delete data!";
    return response.ok({}, msg, reply);
}

module.exports = {
    store, update, show, destroy, get, storeTodoImage
};
