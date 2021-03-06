apt update -y --fix-missing
apt upgrade -y

depends=(neofetch curl nginx cmake libjpeg62-turbo-dev gcc g++ build-essential imagemagick libv4l-dev cmake uvcdynctrl libjpeg8-dev)

if [ "$1" = "up" ]
then
    for depend in ${depends[*]}
    do
        apt install -y ${depend}
    done
fi

if [ "$1" = "down" ] 
then
    for depend in ${depends[*]}
    do
        apt remove -y ${depend}
    done
fi

apt autoremove -y