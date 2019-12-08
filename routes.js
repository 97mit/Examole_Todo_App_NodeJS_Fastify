let users = require ('./controller/users');
let auth = require ('./controller/auth');
let todo = require('./controller/todo');
let middleware = require('./middleware/middleware-token.js');
var path = require('path');
//var bodyParser = require('body-parser');
//var dbSql = require('./mysqldb.jsc');



async function routes(fastify, options) {

    // fastify.use(bodyParser.urlencoded({ extended: false }));
    // fastify.use(bodyParser.json());
    // Route Test
    fastify.post ('/', function (request, reply) {
        console.log("World")

        reply.send ({message: 'Hello World\n'+request.data, code: 200});
    });

    fastify.post('/api/users/register', users.register);
    fastify.post('/api/users/login', users.login);
    fastify.post('/api/token', auth.createToken);
    fastify.post('/api/token/check', auth.checkToken);

   /* fastify.addHook('onRequest', (req, res, next) => {
        fastify.verifyToken(req, res, next);
    });
*/



    /*fastify.post("/test_s", function (req, res) {
        var data = JSON.parse(req.body.data);
        dbname = data.dbName;
        let sql = `CALL USP_GET_TODO(?)`; //Calling procedure in mysql with parameters
        dbSql.execSql(dbname, sql, [JSON.stringify(data.JsonData)])
            .then(result => {
                res.send(result);
            }).catch(err => {
            res.status(500).send({ response: "error" + err });
        });
    });*/


    fastify.route({
        method: 'POST',
        url: '/api/getTodo',

        type:'application/json',
        preHandler: async function(request, reply, done) {
            await middleware.check(request, reply);
            done()
        },

        handler: todo.get
    },);

    fastify.route({
        method: 'POST',
        url: '/api/showTodo',
        preHandler: async function (request, reply, done) {
            await middleware.check(request, reply);
            done()
        },

        handler: todo.show
    });

    fastify.route({
        method: 'POST',
        url: '/api/insertTodo',
        preHandler: async function (request, reply, done) {
            await middleware.check(request, reply);
            //done()
        },
        handler: todo.store
    });

    fastify.route({
        method: 'POST',
        url: '/api/updateTodo',
        preHandler: async function (request, reply, done) {
            await middleware.check(request, reply);
            //done()
        },
        handler: todo.update
    });

    fastify.route({
        method: 'POST',
        url: '/api/deleteTodo',
        preHandler: async function (request, reply, done) {
            await middleware.check(request, reply);
            //done()
        },
        handler: todo.destroy
    });

}

module.exports = routes;
