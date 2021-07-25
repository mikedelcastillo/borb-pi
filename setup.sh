clear && echo "Checking permissions"
is_user_root () { [ "${EUID:-$(id -u)}" -eq 0 ]; }
if is_user_root; then
    echo "Running as root"
else
    echo "You must run this script as root"
    exit 1
fi

clear && echo "Updating system"
apt-get update  -y --fix-missing
apt-get upgrade -y
apt-get autoremove -y

clear && echo "Install linux dependencies"
apt-get install -y git --fix-missing
apt-get install -y nginx --fix-missing

clear && echo "Install node"
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
bash n lts
rm n

clear && echo "Install node dependencies"
npm install -g pm2 nodemon
npm install

clear && echo "Setting up RPI camera"
raspi-config nonint do_camera 0 # Enable the RPI camera
RULE_FILE="/etc/udev/rules.d/100-camera.rules"
rm -rf $RULE_FILE
touch $RULE_FILE
tee -a $RULE_FILE > /dev/null <<EOT
KERNEL=="video*", SUBSYSTEMS=="video4linux", ATTR{name}=="camera0", SYMLINK+="video-pi"
KERNEL=="video*", SUBSYSTEMS=="video4linux", ATTR{name}=="GENERAL WEBCAM: GENERAL WEBCAM", ATTR{index}=="0", SYMLINK+="video-external"
EOT

clear && echo "Setting up mjpeg-streamer"
apt-get install -y cmake libjpeg8-dev gcc g++
rm -rf mjpg-streamer
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd ./mjpg-streamer/mjpg-streamer-experimental/
make
make install
cd ../../

clear && echo "Setup nginx"
npm run nginx

clear && echo "Setting up pm2"
PM2_USER="pi"
SLEEP_RETRY=300
pm2 del all
pm2 start "npm run camera-sd && sleep $SLEEP_RETRY" --name "camera-sd"
pm2 start "npm run camera-ex-sd && sleep $SLEEP_RETRY" --name "camera-ex-sd"

# Disable HD cameras
pm2 start "npm run camera-hd && sleep $SLEEP_RETRY" --name "camera-hd"
pm2 start "npm run camera-ex-hd && sleep $SLEEP_RETRY" --name "camera-ex-hd"
pm2 stop "camera-hd"
pm2 stop "camera-ex-hd"

pm2 start "npm run server" --name "server" --user $PM2_USER

pm2 startup
pm2 save
pm2 status