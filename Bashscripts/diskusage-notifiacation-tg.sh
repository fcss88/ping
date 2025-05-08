#!/bin/bash

# config
THRESHOLD=85
LOG_FILE="/var/log/disk_monitor.log"

BOT_TOKEN="123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"
CHAT_ID="123456789"

DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Send Telegram function
send_telegram() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d text="$message" \
        -d parse_mode="Markdown" > /dev/null
}


### Check disk usage
df -H --output=source,pcent,target | tail -n +2 | while read -r line; do
    USAGE=$(echo "$line" | awk '{print $2}' | tr -d '%')
    MOUNT=$(echo "$line" | awk '{print $3}')
    DEVICE=$(echo "$line" | awk '{print $1}')

    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        MESSAGE="*ДИСК:*  
*host:* $(hostname)  
*mount:* $MOUNT  
*device:* $DEVICE  
*usage:* ${USAGE}%  
*time:* $DATE"

        echo "[$DATE] ALERT (Disk): $DEVICE ($MOUNT) - ${USAGE}%" >> "$LOG_FILE"
        send_telegram "$MESSAGE"
    else
        echo "[$DATE] OK (Disk): $DEVICE ($MOUNT) — ${USAGE}%" >> "$LOG_FILE"
    fi
done

### Перевірка inode
df -i --output=source,ipcent,target | tail -n +2 | while read -r line; do
    IUSAGE=$(echo "$line" | awk '{print $2}' | tr -d '%')
    MOUNT=$(echo "$line" | awk '{print $3}')
    DEVICE=$(echo "$line" | awk '{print $1}')

    if [ "$IUSAGE" -ge "$THRESHOLD" ]; then
        MESSAGE="*INODE:*  
*host:* $(hostname)  
*mount:* $MOUNT  
*device:* $DEVICE  
*Inodes use:* ${IUSAGE}%  
*time:* $DATE"

        echo "[$DATE] ALERT (Inode): $DEVICE ($MOUNT) - ${IUSAGE}% inodes" >> "$LOG_FILE"
        send_telegram "$MESSAGE"
    else
        echo "[$DATE] OK (Inode): $DEVICE ($MOUNT) — ${IUSAGE}% inodes" >> "$LOG_FILE"
    fi
done
