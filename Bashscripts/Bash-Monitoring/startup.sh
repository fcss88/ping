#!/bin/bash
### check toilet if install
if ! command -v toilet &> /dev/null
then
    echo "Toilet not found, installing it now..."
    apt update && apt upgrade -y && apt install toilet -y
else
    echo "Program 'toilet' already installed. lets rock!"
fi

###Create log-file

timestamp=$(date +"%Y-%m-%d_%H%M%S")
touch /root/startuplog-$timestamp.log
### run w, top, netstat, df, history
toilet  -f bigmono9 w > /root/startuplog-$timestamp.log
w >> /root/startuplog-$timestamp.log
toilet  -f bigmono9 top >> /root/startuplog-$timestamp.log
top -b -n 1 >> /root/startuplog-$timestamp.log
toilet  -f bigmono9 netstat >> /root/startuplog-$timestamp.log
netstat >> /root/startuplog-$timestamp.log
toilet  -f bigmono9 df >> /root/startuplog-$timestamp.log
df >> /root/startuplog-$timestamp.log
toilet  -f bigmono9 history >> /root/startuplog-$timestamp.log
cat /root/.bash_history >> /root/startuplog-$timestamp.log
exit 0
