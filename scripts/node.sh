depends=(n pm2 nodemon)
version=16

if [ "$1" = "up" ] 
then
    # Install n
    sudo -u $USER curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
    sudo -u $USER rm n

    # Install node dependencies
    for depend in ${depends[*]}
    do
        npm install --global ${depend}
    done

    # Install node
    n install ${version}

    # Install project
    sudo -u $USER npm install
fi

if [ "$1" = "down" ] 
then
    # Delete node
    sudo -u $USER rm n ${version}

    # Install node dependencies
    for depend in ${depends[*]}
    do
        npm uninstall --global ${depend}
    done

    # Delete n
    rm -rf /usr/local/n

    # Delete node_modules
    rm -rf node_modules
fi