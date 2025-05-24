#!/bin/bash
# Config
PROCESS_NAME="nginx"
SERVICE_NAME="nginx"
LOG_FILE="/var/log/process_watchdog.log"
RESTART_CMD="systemctl restart $SERVICE_NAME"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Timestamp
NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Check if process is running
# pgrep -x checks for exact match of the process name
# /dev/null because we don't need to see the process PID in the output
# just exit-code 0 [success] or 1 [failure]
if pgrep -x "$PROCESS_NAME" > /dev/null; then
# if pgrep returns 0, the process is running
    echo "[$NOW] Process '$PROCESS_NAME' is running." >> "$LOG_FILE"
else
# if pgrep returns 1, the process is not running    
    echo "[$NOW] Process '$PROCESS_NAME' is NOT running. Attempting restart..." >> "$LOG_FILE"
    $RESTART_CMD

    # Check again after restart attempt
    sleep 2
    if pgrep -x "$PROCESS_NAME" > /dev/null; then
        echo "[$NOW] Restart successful." >> "$LOG_FILE"
    else
        echo "[$NOW] Restart FAILED." >> "$LOG_FILE"
    fi
fi
