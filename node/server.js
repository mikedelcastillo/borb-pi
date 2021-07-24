require("dotenv").config()

const Hapi = require('@hapi/hapi')
const Boom = require('@hapi/boom')
const Joi = require('joi')
const consola = require('consola')
const uuid4 = require('uuid').v4
const IOServer = require("socket.io").Server

require("./scripts/notify")

const {CAMERA_PORT, SERVER_PORT} = process.env

const hapiServer = Hapi.server({
    port: SERVER_PORT,
    host: "0.0.0.0",
    routes: {
        cors: {
            origin: ['*'],
            credentials: true,
        },  
    },
    debug: {
        request: ['error'],
    },
})

process.on('unhandledRejection', (err) => {
    consola.error(err)
    process.exit(1)
})

const init = async () => {
    consola.info(`Server started http://localhost:${SERVER_PORT}`)
    const ioServer = new IOServer(hapiServer.listener)
    let ioClient = null

    ioServer.on('connection', (socket) => {
        consola.info(`New connection`)

        socket.on('disconnect', (socket) => {
            consola.info(`Disconnected`)
        })
    })


    
    hapiServer.route({
        method: 'GET',
        path: '/api/',
        config: {
            handler: async (request, h) => {
                return "hello!"
            },
            validate: {
                query: Joi.object({
                    
                }),
            },
        },
    })

    await hapiServer.start()
}

init()