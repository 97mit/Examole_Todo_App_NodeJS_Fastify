const fastify = require('fastify')()
const concat = require('concat-stream')
const fs = require('fs')
const pump = require('pump')

fastify.register(require('fastify-multipart'))

fastify.post('/', function (req, reply) {
    const mp = req.multipart(handler, function (err) {
        console.log('upload completed')
        reply.code(200).send({"ggg":200})
    })

    // mp is an instance of
    // https://www.npmjs.com/package/busboy

    mp.on('field', function (key, value) {
        console.log('form-data', key, value)
    })

    function handler (field, file, filename, encoding, mimetype) {
        // to accumulate the file in memory! Be careful!
        //
        // file.pipe(concat(function (buf) {
        //   console.log('received', filename, 'size', buf.length)
        // }))
        //
        // or

        pump(file, fs.createWriteStream('fastify_images'))

        // be careful of permission issues on disk and not overwrite
        // sensitive files that could cause security risks
    }
})

fastify.listen(3000, err => {
    if (err) throw err
    console.log(`server listening on ${fastify.server.address().port}`)
})
