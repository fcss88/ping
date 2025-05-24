#!/bin/bash

# Configuration
LOG_FILE="/var/log/nginx/access.log"
ARCHIVE_DIR="./archive"
ROTATE_LOG="./logs/rotate.log"
MAX_SIZE_MB=20

# Create directories if needed
mkdir -p "$ARCHIVE_DIR"
mkdir -p "$(dirname "$ROTATE_LOG")"

# Get current size
FILE_SIZE_MB=$(du -m "$LOG_FILE" | cut -f1)

# Timestamp
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')

# Check size
if [ "$FILE_SIZE_MB" -ge "$MAX_SIZE_MB" ]; then
    ARCHIVE_NAME="$(basename "$LOG_FILE" .log)-$TIMESTAMP.log.gz"
    ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"

    # Compress and move
    gzip -c "$LOG_FILE" > "$ARCHIVE_PATH"

    # Truncate original
    : > "$LOG_FILE"

    # Log action
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Rotated $LOG_FILE to $ARCHIVE_PATH (size: ${FILE_SIZE_MB}MB)" >> "$ROTATE_LOG"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No rotation needed for $LOG_FILE (size: ${FILE_SIZE_MB}MB)" >> "$ROTATE_LOG"
fi
