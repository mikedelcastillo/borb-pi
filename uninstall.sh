is_user_root () { [ "${EUID:-$(id -u)}" -eq 0 ]; }
if is_user_root; then
    echo "Running as root"
else
    echo "You must run this script as root"
    exit 1
fi

bash ./scripts/pm2.sh down
bash ./scripts/camera.sh down
bash ./scripts/node.sh down
bash ./scripts/system.sh down