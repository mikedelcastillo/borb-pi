if [ "$1" = "up" ] 
then
    raspi-config nonint do_camera 0 # Enable the RPI camera

    rm -rf mjpg-streamer
    sudo -u $USER git clone https://github.com/jacksonliam/mjpg-streamer.git
    cd ./mjpg-streamer/mjpg-streamer-experimental/
    cmake
    make USE_LIBV4L2=true clean all
    make install
    cd ../../

    modprobe bcm2835-v4l2
    rm -rf /etc/modules
    echo "bcm2835-v4l2" >> /etc/modules
    usermod -a -G video $USER
fi

if [ "$1" = "down" ] 
then
    raspi-config nonint do_camera 1 # Disable the RPI camera
    
    rm -rf mjpg-streamer

    rm -rf /etc/modules
    touch /etc/modules
fi