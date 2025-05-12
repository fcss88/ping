#!/bin/bash
HOST="localhost"
PORT=445
LOG="/var/log/samba/port_check.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

if nc -z "$HOST" "$PORT"; then
  echo "[$DATE] Samba avaliable, port $PORT" >> "$LOG"
else
  echo "[$DATE] Samba unavaliable, port $PORT" >> "$LOG"
fi