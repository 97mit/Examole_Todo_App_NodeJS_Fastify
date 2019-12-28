let users = require ('./controller/users');
let auth = require ('./controller/auth');
let todo = require('./controller/todo');
let middleware = require('./middleware/middleware-token.js');
var path = require('path');
//var bodyParser = require('body-parser');
//var dbSql = require('./mysqldb.jsc');
const fastify = require('fastify');
let multer  = require('fastify-multer');
let crypto = require('crypto');
const storage =  multer.diskStorage({
    destination: function(req, file, cb){
        cb(null,'fastify_images');
    },
    filename: function (req, file, cb) {
        let rand = crypto.randomBytes(10).toString('hex');
        cb(null, rand+"_"+ file.originalname);
    }
})

let upload  = multer({ storage: storage })
async function routes(fastify, options) {
    //fastify.register(multer.contentParser)
    // fastify.use(bodyParser.urlencoded({ extended: false }));
    // fastify.use(bodyParser.json());
    // Route Test

    /*fastify.post('/single',upload.single('avatar'), function(req, res) {
        console.log(req.body);
        console.log(req.file)
        res.send({"hello":req.body});
    });*/
    fastify.route({
        method: 'POST',
        url: '/',
        preHandler: upload.none(),
        handler: function (request, reply) {
            console.log("World")
            console.log(request.body)
            reply.send({message: 'Hello World\n', code: 200, data: request.body});
        }
    });
    fastify.route({
        method: 'POST',
        url: '/api/users/register',
        preHandler: upload.single('avatar'),
        handler: await users.register
    });

    fastify.route({
        method: 'POST',
        url: '/api/users/login',
        preHandler: upload.none(),
        handler: await users.login
    });
    fastify.route({
        method: 'POST',
        url: '/api/token',
        preHandler: upload.none(),
        handler: await auth.createToken
    });
    fastify.route({
        method: 'POST',
        url: '/api/token/check',
        preHandler: upload.none(),
        handler: await auth.checkToken
    });
    //fastify.post('/api/users/register', users.register);
    //fastify.post('/api/users/login', users.login);
    //fastify.post('/api/token', auth.createToken);
    //fastify.post('/api/token/check', auth.checkToken);

   /* fastify.addHook('onRequest', (req, res, next) => {
        fastify.verifyToken(req, res, next);
    });
*/

    fastify.route({
        method: 'POST',
        url: '/api/getTodo',

        preHandler:[upload.none(),async function(request, reply, done) {

            await middleware.check(request, reply);
            done()
        }],
        handler: todo.get
    },);

    fastify.route({
        method: 'POST',
        url: '/api/showTodo',

        preHandler: [upload.none(),async function (request, reply, done) {
            await middleware.check(request, reply);
            done()
        }],

        handler: todo.show
    });

    fastify.route({
        method: 'POST',
        url: '/api/insertTodo',
        preHandler: [upload.none(),async function (request, reply, done) {
            await middleware.check(request, reply);
            done()
        }],
        handler: todo.store
    });
    fastify.route({
        method: 'POST',
        url: '/api/insertTodoImage',
        preHandler: [upload.none(),async function (request, reply, done) {
            await middleware.check(request, reply);
            done()
        }],
        handler: todo.storeTodoImage
    });

    fastify.route({
        method: 'POST',
        url: '/api/updateTodo',
        preHandler: [upload.none(),async function (request, reply, done) {
            await middleware.check(request, reply);
            done()
        }],
        handler: todo.update
    });

    fastify.route({
        method: 'POST',
        url: '/api/deleteTodo',
        preHandler: [upload.none(),async function (request, reply, done) {
            await middleware.check(request, reply);
            done()
        }],
        handler: todo.destroy
    });

}

module.exports = routes;
