require("dotenv").config()

const shell = require('shelljs')
const fs = require('fs')

const DOMAIN = process.argv[2]

const nginx = 
`server {
    listen 80;
    server_name ${DOMAIN};
    root /home/pi/borb-pi/client/dist;
    index index.html;
    error_page 404 /index.html;
    location /api {
        proxy_pass  http://localhost:${process.env.SERVER_PORT}/api;
    }
    location /camera {
        rewrite    /camera/(.*) /$1 break;
        proxy_pass  http://localhost:${process.env.CAMERA_SD_PORT}/;
    }
    location /camera/hd {
        rewrite    /camera/hd/(.*) /$1 break;
        proxy_pass  http://localhost:${process.env.CAMERA_HD_PORT}/;
    }
    location /camera/external {
        rewrite    /camera/external/(.*) /$1 break;
        proxy_pass  http://localhost:${process.env.CAMERA_EX_SD_PORT}/;
    }
    location /camera/external/hd {
        rewrite    /camera/external/hd/(.*) /$1 break;
        proxy_pass  http://localhost:${process.env.CAMERA_EX_HD_PORT}/;
    }
}`

console.log(nginx)

fs.writeFileSync("/etc/nginx/sites-available/default", nginx)

shell.exec("systemctl stop nginx")
shell.exec("systemctl status nginx")
shell.exec("systemctl start nginx")
shell.exec("systemctl status nginx")

process.exit()