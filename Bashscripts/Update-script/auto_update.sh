#!/bin/bash

LOG_FILE="/var/log/auto_update/update.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$DATE] $1" >> "$LOG_FILE"
}

update_apt() {
    log "Starting APT update..."
    apt update >> "$LOG_FILE" 2>&1 && \
    apt upgrade -y >> "$LOG_FILE" 2>&1 && \
    log "APT update and upgrade completed successfully." || \
    log "APT update or upgrade failed."
}

update_yum() {
    log "Starting YUM update..."
    yum update -y >> "$LOG_FILE" 2>&1 && \
    log "YUM update completed successfully." || \
    log "YUM update failed."
}

# Detect package manager and update accordingly
if command -v apt >/dev/null 2>&1; then
    update_apt
elif command -v yum >/dev/null 2>&1; then
    update_yum
else
    log "No supported package manager found (apt or yum)."
    exit 1
fi
