#!/bin/bash
echo "Check docker"
if docker -v &> /dev/null; then
    echo "Docker is present: $(docker -v)"
else
    echo "Docker not found"
    exit 1
fi

mkdir -p /app/tinyproxy/logs/
touch /app/tinyproxy/logs/tinyproxy.log

docker build -t tpind .
docker run -p 8888:8888 -d --name tpind_container -v /app/tinyproxy/logs:/var/log/tinyproxy tpind
exit 0
