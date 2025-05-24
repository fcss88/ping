#!/bin/bash

# Directories
LOG_DIR="./logs"
CSV_LOG="$LOG_DIR/system_monitor.csv"
JSON_LOG="$LOG_DIR/system_monitor.json"
mkdir -p "$LOG_DIR"

# Timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# CPU Load
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | xargs)

# RAM Usage
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

# Disk Usage
DISK_USED_PERCENT=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# Open File Descriptors
FD_COUNT=$(lsof | wc -l)

# Terminal output
echo "Timestamp: $TIMESTAMP"
echo "CPU Load: $CPU_LOAD"
echo "RAM Usage: $MEM_USED MB / $MEM_TOTAL MB"
echo "Disk Usage: $DISK_USED_PERCENT%"
echo "Open File Descriptors: $FD_COUNT"

# CSV output
if [ ! -f "$CSV_LOG" ]; then
  echo "timestamp,cpu_load,ram_used_mb,ram_total_mb,disk_used_percent,fd_count" > "$CSV_LOG"
fi
echo "$TIMESTAMP,$CPU_LOAD,$MEM_USED,$MEM_TOTAL,$DISK_USED_PERCENT,$FD_COUNT" >> "$CSV_LOG"

# JSON output
JSON_ENTRY=$(cat <<EOF
{
  "timestamp": "$TIMESTAMP",
  "cpu_load": $CPU_LOAD,
  "ram_used_mb": $MEM_USED,
  "ram_total_mb": $MEM_TOTAL,
  "disk_used_percent": $DISK_USED_PERCENT,
  "fd_count": $FD_COUNT
}
EOF
)

echo "$JSON_ENTRY" >> "$JSON_LOG"
