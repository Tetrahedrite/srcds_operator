const Rcon = require('rcon-srcds').default;
const fs = require('fs');
const server = new Rcon({ host: process.argv[2], port: Number(process.argv[3]), encoding: 'utf8', timeout: 1000 });
server.authenticate(fs.readFileSync('.rcon_password', 'utf-8'))
    .then(() => {
        console.log('authenticated ' + server.host + ', with port ' + server.port + ', with message ' + process.argv[4]);
        if (process.argv[4] === undefined || process.argv[4] === "") {
            process.exit()
            return;
        }
        // for (let messageLoop = 2; messageLoop < process.argv.length; messageLoop++) {
        server.execute('say ' + process.argv.slice(4, process.argv.length).join(" "));
        process.exit()
        // }
    })
    .then(function(result) {
        console.log(result);
        process.exit()
    })
    .catch(console.error);

setTimeout(process.exit, server.timeout);
