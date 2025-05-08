#!/bin/bash

# disk space threshold 
THRESHOLD=85

# admin mail
EMAIL="admin@example.com"


df -H --output=source,pcent,target | tail -n +2 | while read -r line; do
    USAGE=$(echo "$line" | awk '{print $2}' | tr -d '%')
    MOUNT=$(echo "$line" | awk '{print $3}')
    
    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        echo -e "Attention! Disk usage $MOUNT up then $THRESHOLD% (current: ${USAGE}%)\n\n$line" | \
        mail -s "Disk $MOUNT full at $(hostname)" "$EMAIL"
    fi
done
