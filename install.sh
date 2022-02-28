is_user_root () { [ "${EUID:-$(id -u)}" -eq 0 ]; }
if is_user_root; then
    echo "Running as root"
else
    echo "You must run this script as root"
    exit 1
fi

git reset --hard HEAD
git pull

if [ $1 = "reset" ] 
then
    bash ./uninstall.sh
fi

bash ./scripts/system.sh up
bash ./scripts/node.sh up
bash ./scripts/camera.sh up