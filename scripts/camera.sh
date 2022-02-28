if [ "$1" = "up" ] 
then
    raspi-config nonint do_camera 0 # Enable the RPI camera

    cd ~
    rm -rf mjpg-streamer
    git clone https://github.com/jacksonliam/mjpg-streamer.git
    cd ~/mjpg-streamer/mjpg-streamer-experimental/
    make
    make install
    cd ~
fi

if [ "$1" = "down" ] 
then
    raspi-config nonint do_camera 1 # Disable the RPI camera
    
    cd ~
    rm -rf mjpg-streamer
fi