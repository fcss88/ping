
# TPinD

Tinyproxy in Docker container. 

You can use it, but just change your ip in *tinyproxy.conf* (the 20th line)


## Files decrpiption

- **Dockerfile** describe rules for docker container

- **restart.sh** restart proxy, rotate logs, You can add it in cron

- **start.sh** first start proxy, create logs

- **tinyproxy.conf** configurable file for proxy, read docs 

- **tpind-full-install.sh** one file project

## one file usage 

```bash
  ./tpind-full-install.sh allowed_ip proxy port

  # example
  ./tpind-full-install.sh 192.168.14.88 3128
```



## Docs link

 - [Tinyproxy homepage](https://tinyproxy.github.io/)


## Installation, working

first run for root

```bash
  chmod +x start.sh && ./start.sh
```

for logrotate, CI/CD etc don't forget:

```bash
  chmod +x restart.sh 
```
