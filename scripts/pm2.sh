user=pi

sudo -u $user pm2 status
sudo -u $user pm2 stop all
sudo -u $user pm2 del all

if [ "$1" = "up" ] 
then
    sudo -u $user pm2 del all
    sudo -u $user pm2 start "npm run camera-0" --name "camera-0"
    sudo -u $user pm2 start "npm run camera-1" --name "camera-1"
    sudo -u $user pm2 save
    pm2 startup
fi


if [ "$1" = "down" ] 
then
    pm2 unstartup
fi

sudo -u $user pm2 status