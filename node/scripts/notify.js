const { sendMessage } = require('../services/telegram')


// https://stackoverflow.com/questions/3653065/get-local-ip-address-in-node-js
function getIPs(){
    const { networkInterfaces } = require('os')

    const nets = networkInterfaces()
    const results = []
    
    for (const name of Object.keys(nets)) {
        for (const net of nets[name]) {
            if (net.family === 'IPv4' && !net.internal) {
                results.push([name, net.address])
            }
        }
    }

    return results
}

const ipAddresses = getIPs()


sendMessage(ipAddresses.map(([name, ip]) => [
    name,
    `http://${ip}/`,
    `http://${ip}/camera/?action=snapshot`,
    `http://${ip}/camera/?action=stream`,
].join("\n")).join("\n"))