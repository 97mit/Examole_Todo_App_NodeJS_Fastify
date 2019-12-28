require ('dotenv'). config ();
const fastify = require('fastify')({
    logger: true // enable this to receive every log request from fastify.
});
let multer  = require('fastify-multer');


let users = require ('../controller/users');
let auth = require ('../controller/auth');
let todo = require('../controller/todo');
let middleware = require('../middleware/middleware-token.js');
var path = require('path');

const server = fastify;
server.register(multer.contentParser)

const storage =  multer.diskStorage({
    destination: function(req, file, cb){
        cb(null,'fastify_images');
    },
    filename: function (req, file, cb) {

        let rand = Math.random().toString(36);
        cb(null, rand+"_"+ file.originalname);
    }
})

let upload  = multer({ storage: storage })

server.route({
    method: 'POST',
    url: '/',
    preHandler: upload.none(),
    handler: function (request, reply) {
        console.log("World")
        console.log(request.body)
        reply.send({message: 'Hello World\n', code: 200, data: request.body});
    }
});

server.route({
    method: 'POST',
    url: '/single',
    preHandler: upload.single('somefile'),
    handler: function(request, reply) {
        // request.file is the `avatar` file

        reply.code(200).send(request.body)
    }
})

server.route({
    method: 'POST',
    url: '/array',
    preHandler: upload.array('somefile', 12),
    handler: function(request, reply) {
        // request.files is array of `photos` files
        // request.body will contain the text fields, if there were any
        reply.code(200).send('SUCCESS')
    }
})

const start = async () => {
    try{
        //Use the Port from ENV APP_PORT, if there is no such variable then it will use port 3000
        await server.listen(process.env.APP_PORT || 3000);
        server.log.info(`server listening on ${server.server.address().port}`)
    }catch(err){
        server.log.error(err);
        process.exit(1);
    }
};
// Run the server!
start();

