#!/bin/bash

LOG_FILE="/var/log/suspicious_logins/report.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# === Detect OS type and set log path ===
if [ -f /etc/debian_version ]; then
    AUTH_LOG="/var/log/auth.log"
elif [ -f /etc/redhat-release ]; then
    AUTH_LOG="/var/log/secure"
else
    echo "Unsupported Linux distribution. Exiting."
    exit 1
fi

# === Ensure log directory exists ===
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$DATE] $1" >> "$LOG_FILE"
}

# === Start Log ===
log "=== Suspicious Login Check Started ==="
log "Analyzing file: $AUTH_LOG"

# === Failed login attempts ===
log "Failed login attempts:"
grep "Failed password" "$AUTH_LOG" | awk '{print $1, $2, $3, $11}' | sort | uniq -c | sort -nr >> "$LOG_FILE"

# === Top offending IPs ===
log "Top offending IPs:"
grep "Failed password" "$AUTH_LOG" | awk '{print $11}' | sort | uniq -c | sort -nr | head -10 >> "$LOG_FILE"

# === Successful non-local logins ===
log "Successful external logins:"
grep "Accepted password" "$AUTH_LOG" | grep -vE "127.0.0.1|localhost" | awk '{print $1, $2, $3, $11}' >> "$LOG_FILE"

# === End Log ===
log "=== Check Completed ==="
echo "" >> "$LOG_FILE"
