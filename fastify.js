require ('dotenv'). config ();

// Fastify initial initialization.
const fastify = require ('fastify') ({
    logger: true // enable this to receive every log request from fastify.
});

// This function is to enable us to post through www-url-encoded.
fastify.register (require ('fastify-formbody'));
fastify.register(require('fastify-multipart'))
// Route separated from the root file.
fastify.register (require ('./routes'));

// The root file function is async.
const start = async () => {
    try {
        // Use the Port from ENV APP_PORT, if there is no such variable then it will use port 3000
        await fastify.listen (process.env.APP_PORT || 3000);

        fastify.log.info (`server listening on ${fastify.server.address (). port}`)
    } catch (err) {
        fastify.log.error (err);
        process.exit (1)
    }
};

// Run the server!
start();
