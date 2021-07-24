require("dotenv").config()

const shell = require('shelljs')
const fs = require('fs')

const DOMAIN = process.argv[2]

const {CAMERA_PORT, SERVER_PORT} = process.env

const nginx = 
`server {
    listen 80;
    server_name ${DOMAIN};
    root /home/pi/borb-pi/client/dist;
    index index.html;
    error_page 404 /index.html;
    location /api {
        proxy_pass  http://localhost:${SERVER_PORT}/api;
    }
    location /camera {
        rewrite    /camera/(.*) /$1 break;
        proxy_pass  http://localhost:${CAMERA_PORT}/;
    }
}`

fs.writeFileSync("/etc/nginx/sites-available/default", nginx)

shell.exec("systemctl stop nginx")
shell.exec("systemctl status nginx")
shell.exec("systemctl start nginx")
shell.exec("systemctl status nginx")

process.exit()