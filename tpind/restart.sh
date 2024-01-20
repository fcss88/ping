#!/bin/bash
# stop and delete containers
docker stop tpind_container && docker rm tpind_container
# delete images
docker rmi --force tpind

# save current dir as a variable 
curr_dir=$(pwd)
#rotate logs 
curr_dir=$(pwd)
cd /app/tinyproxy/logs/
tar -czf "tinyproxy_$(date +"%Y_%m_%d_$(date +%s)").tar.gz" "tinyproxy.log"
rm tinyproxy.log
touch /app/tinyproxy/logs/tinyproxy.log
# return to project home directory
cd "$curr_dir"

mkdir -p /app/tinyproxy/logs/
touch /app/tinyproxy/logs/tinyproxy.log
# build and run tinyproxy in docker 
docker build -t tpind .
docker run -p 8888:8888 -d --name tpind_container -v /app/tinyproxy/logs:/var/log/tinyproxy tpind
exit 0
