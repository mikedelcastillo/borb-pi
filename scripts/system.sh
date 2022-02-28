apt update -y --fix-missing
apt upgrade -y

depends=(neofetch curl nginx cmake libjpeg8-dev gcc g++)

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