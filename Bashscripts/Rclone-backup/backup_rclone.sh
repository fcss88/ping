#!/bin/bash

# Configs
SOURCE_DIR="/app"
BACKUP_DIR="./data"
LOG_FILE="./logs/backup.log"
REMOTE_NAME="cloudremote"
REMOTE_PATH="backups"

# Create  directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Timestamp
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# Start log entry
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting backup..." >> "$LOG_FILE"

# Archive
tar -czf "$ARCHIVE_PATH" "$SOURCE_DIR" 2>> "$LOG_FILE"
if [ $? -ne 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to archive data." >> "$LOG_FILE"
    exit 1
fi

# Upload to cloud
rclone copy "$ARCHIVE_PATH" "$REMOTE_NAME:$REMOTE_PATH" --log-file="$LOG_FILE" --log-level INFO
if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup uploaded to cloud successfully: $ARCHIVE_NAME" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Failed to upload backup to cloud." >> "$LOG_FILE"
    exit 1
fi
