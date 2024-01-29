#!/bin/bash
# downloading files for project
wget -q https://raw.githubusercontent.com/fcss88/ping/main/tpind/Dockerfile
wget -q https://raw.githubusercontent.com/fcss88/ping/main/tpind/restart.sh
wget -q https://raw.githubusercontent.com/fcss88/ping/main/tpind/start.sh
wget -q https://raw.githubusercontent.com/fcss88/ping/main/tpind/tinyproxy.conf
# changes in tinyproxy config-file
sed -i "s/169.254.169.254/$1/g" "tinyproxy.conf"
sed -i "s/8888/$2/g" "tinyproxy.conf"

# change port in other files
sed -i "s/8888/$2/g" "Dockerfile"
sed -i "s/8888/$2/g" "restart.sh"
sed -i "s/8888/$2/g" "start.sh"

echo "Allowed IP-address for proxy: $1"
echo -e "\e[1;31mUse this settings for proxy `curl -s ip.cx.ua`:$2\e[0m"
exit 0