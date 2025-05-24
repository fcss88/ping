#!/bin/bash

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/system_monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$LOG_DIR"

echo "==============START= $TIMESTAMP ====================" >> "$LOG_FILE"

# CPU load
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | xargs)
echo "CPU Load: $CPU_LOAD" >> "$LOG_FILE"

# RAM
MEM_USED=$(free -m | awk '/Mem:/ {print $3 "MB / " $2 "MB"}')
echo "RAM Usage: $MEM_USED" >> "$LOG_FILE"

# Disk
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5 " used on " $1}')
echo "Disk Usage: $DISK_USAGE" >> "$LOG_FILE"

# Open file descriptors
FD_COUNT=$(lsof | wc -l)
echo "Open File Descriptors: $FD_COUNT" >> "$LOG_FILE"

# Top 5 by CPU
echo "Top 5 CPU-consuming processes:" >> "$LOG_FILE"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6 >> "$LOG_FILE"

# Top 5 by RAM
echo "Top 5 Memory-consuming processes:" >> "$LOG_FILE"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6 >> "$LOG_FILE"
echo "=============FINISH= $TIMESTAMP ====================" >> "$LOG_FILE"

echo "" >> "$LOG_FILE"
