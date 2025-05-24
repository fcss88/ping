#!/bin/bash

# Config
CONFIG_FILE="./services.conf"
LOG_FILE="./logs/watchdog.log"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Timestamp
NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Read config file line by line
while IFS=: read -r PROCESS_NAME SERVICE_NAME; do
    # Skip empty or commented lines
    [[ -z "$PROCESS_NAME" || "$PROCESS_NAME" =~ ^# ]] && continue

    echo "[$NOW] Checking process: $PROCESS_NAME" >> "$LOG_FILE"

    if pgrep -x "$PROCESS_NAME" > /dev/null; then
        echo "[$NOW] '$PROCESS_NAME' is running." >> "$LOG_FILE"
    else
        echo "[$NOW] '$PROCESS_NAME' is NOT running. Attempting restart of '$SERVICE_NAME'..." >> "$LOG_FILE"
        systemctl restart "$SERVICE_NAME"

        sleep 2
        if pgrep -x "$PROCESS_NAME" > /dev/null; then
            echo "[$NOW] Restart of '$SERVICE_NAME' successful." >> "$LOG_FILE"
        else
            echo "[$NOW] Restart of '$SERVICE_NAME' FAILED!" >> "$LOG_FILE"
        fi
    fi
done < "$CONFIG_FILE"
