#!/bin/bash

LOG_DIR="/var/log/firewall_monitor"
mkdir -p "$LOG_DIR"

DATE=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/ufw_$DATE.log"
JSON_FILE="$LOG_DIR/ufw_$DATE.json"
CSV_FILE="$LOG_DIR/ufw_$DATE.csv"

# === LOG ===
{
    echo "=== UFW STATUS ==="
    date
    echo
    ufw status verbose
    echo
    echo "=== UFW RULES LOG ==="
    grep UFW /var/log/syslog 2>/dev/null || grep UFW /var/log/messages 2>/dev/null
} >> "$LOG_FILE"

# === CSV & JSON ===
echo "[" > "$JSON_FILE"
echo "To,Action,From" > "$CSV_FILE"

ufw status | awk '
/^To/ { next }
/^[0-9a-zA-Z]/ {
    to=$1; action=$2; from=$3
    printf "{\"to\":\"%s\",\"action\":\"%s\",\"from\":\"%s\"},\n", to, action, from >> "'"$JSON_FILE"'"
    printf "%s,%s,%s\n", to, action, from >> "'"$CSV_FILE"'"
}
'

truncate -s-2 "$JSON_FILE"
echo -e "\n]" >> "$JSON_FILE"

echo "[OK] UFW log written to $LOG_FILE"
echo "[OK] Exported to $CSV_FILE and $JSON_FILE"
