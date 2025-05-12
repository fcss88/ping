#!/bin/bash
LOG="/var/log/samba/log.smbd"
OUT="/var/log/samba/user_activity_report.csv"

echo "User,IP,Time" > "$OUT"
grep "smbd_open_connection" "$LOG" | while read -r line; do
  IP=$(echo "$line" | awk -F' ' '{print $NF}')
  USER=$(echo "$line" | grep -oP "uid=\K[^ ]+")
  TIME=$(echo "$line" | cut -d']' -f1 | tr -d '[')
  echo "$USER,$IP,$TIME" >> "$OUT"
done

echo "Report saved in $OUT"
