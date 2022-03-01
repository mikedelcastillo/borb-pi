depends=(n pm2 nodemon)
version=16
user=pi

if [ "$1" = "up" ] 
then
    # Install n
    sudo -u $user curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
    sudo -u $user rm n

    # Install node dependencies
    for depend in ${depends[*]}
    do
        npm install --global ${depend}
    done

    # Install node
    n install ${version}
fi

if [ "$1" = "down" ] 
then
    # Delete node
    sudo -u $user rm n ${version}

    # Install node dependencies
    for depend in ${depends[*]}
    do
        npm uninstall --global ${depend}
    done

    # Delete n
    rm -rf /usr/local/n
fi