echo "Checking permissions"
is_user_root () { [ "${EUID:-$(id -u)}" -eq 0 ]; }
if is_user_root; then
    echo "Running as root"
else
    echo "You must run this script as root"
    exit 1
fi

echo "Updating system"
apt-get update  -y --fix-missing
apt-get upgrade -y
apt-get autoremove -y

echo "Install linux dependencies"
apt-get install -y git --fix-missing

echo "Install node"
curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
bash n lts
rm n

echo "Install node dependencies"
npm install -g pm2 nodemon
npm install

echo "Setting up mjpeg-streamer"
raspi-config nonint do_camera 1
apt-get install -y cmake libjpeg8-dev gcc g++
rm -rf mjpg-streamer
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd ./mjpg-streamer/mjpg-streamer-experimental/
make
make install
cd ../../

echo "Setting up pm2"
PM2_USER="pi"
pm2 del all
pm2 start "npm run camera-hd" --name "camera"
pm2 startup
pm2 save
pm2 status