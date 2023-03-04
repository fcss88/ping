#!/bin/bash
############################################################
### Just simple proxy https://tinyproxy.github.io/       ###
### Tested on Debian 10 root-user                        ###
### Your need open port 8888 or another for proxy        ###
### config file: /etc/tinyproxy/tinyproxy.conf           ### 
### log-files directory /var/log/tinyproxy/              ###
############################################################

# Am I root?
if [ "x$(id -u)" != 'x0' ]; then
    echo 'Error: this script can only be executed by root'
    exit 1
fi
set -e
### Set Ukraine TimeZone
timedatectl set-timezone Europe/Kiev

## update and install packages 
apt update
apt full-upgrade -y
apt install curl -y
apt install wget -y
apt install links -y
apt install links2 -y
apt install whois -y
apt install mc -y
apt install dnsutils -y
apt install whois -y
apt install tinyproxy -y

## Backup tinyproxy config-file
cp /etc/tinyproxy/tinyproxy.conf /etc/tinyproxy/tutinyproxy.conftinyproxy.conf.backup

## Crate new config file tinyproxy.conf
################# BEGIN CREATING TINYPROXY CONF-FILE ################################
echo User tinyproxy > /etc/tinyproxy/tinyproxy.conf
echo Group tinyproxy >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
#### change port if u want and dont forget open it 
echo Port 8888 >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
echo Timeout 600 >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
echo DefaultErrorFile "\"/usr/share/tinyproxy/default.html\"" >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf 
echo StatFile "\"/usr/share/tinyproxy/stats.html\"" >> /etc/tinyproxy/tinyproxy.conf
echo LogFile "\"/var/log/tinyproxy/tinyproxy.log\"" >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
echo LogLevel Info >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf 
echo PidFile "\"/run/tinyproxy/tinyproxy.pid\"" >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf 
echo MaxClients 200 >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf 
echo MinSpareServers 5 >> /etc/tinyproxy/tinyproxy.conf
echo MaxSpareServers 20 >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
echo StartServers 10 >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
echo MaxRequestsPerChild 0 >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
echo Allow 127.0.0.1 >> /etc/tinyproxy/tinyproxy.conf

echo Allow 148.210.110.11 >> /etc/tinyproxy/tinyproxy.conf
###### Put ^^^^^^^^^^^^^^ your client ip here (from ip.cx.ua for example)

echo >> /etc/tinyproxy/tinyproxy.conf
echo ViaProxyName "\"tinyproxy\"" >> /etc/tinyproxy/tinyproxy.conf
echo >> /etc/tinyproxy/tinyproxy.conf
echo ConnectPort 443 >> /etc/tinyproxy/tinyproxy.conf
echo ConnectPort 563 >> /etc/tinyproxy/tinyproxy.conf

################# END CREATING TINYPROXY CONF-FILE ##################################


### Restart tinyproxy
systemctl restart tinyproxy.service
sleep 10

### Add daily service restaring in cron at 04:04 AM  
crontab -l > supercron
echo "04 04 * * * systemctl restart tinyproxy.service" >> supercron
crontab supercron
rm supercron

### Show ServerIP Tinyproxy
RED='\033[0;31m'
echo -e "$RED IP Server is `curl ip.cx.ua` and port 8888"
exit 1