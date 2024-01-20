# Created date 20 Jan 2024
FROM alpine:latest

EXPOSE 8888

RUN apk upgrade --no-cache \
    && apk add --no-cache tinyproxy \
    && apk add --no-cache curl

ENTRYPOINT [ "/usr/bin/tinyproxy", "-d" ]

COPY tinyproxy.conf /etc/tinyproxy/
