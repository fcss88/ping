#!/bin/bash

# === Variables ===
LOG_FILE="/var/log/inventory/inventory.log"
CSV_FILE="/var/log/inventory/inventory.csv"
JSON_FILE="/var/log/inventory/inventory.json"

# === Create log directory if missing ===
mkdir -p "$(dirname "$LOG_FILE")"

# === Initialize CSV and JSON ===
echo "hostname,ip,uptime,packages,cpu_load,ram_usage,disk_free,inodes_free" > "$CSV_FILE"
echo "[" > "$JSON_FILE"

# === Functions ===

get_hostname() {
    hostname
}

get_ip() {
    hostname -I | awk '{print $1}'
}

get_uptime() {
    uptime -p | sed 's/up //'
}

get_package_count() {
    if command -v dpkg >/dev/null 2>&1; then
        dpkg -l | grep -c ^ii
    elif command -v rpm >/dev/null 2>&1; then
        rpm -qa | wc -l
    else
        echo "0"
    fi
}

get_cpu_load() {
    awk '{print $1}' /proc/loadavg
}

get_ram_usage() {
    free -m | awk '/Mem:/ {printf "%.2f", ($3/$2)*100}'
}

get_disk_free() {
    df -h / | awk 'NR==2 {print $4}'
}

get_inodes_free() {
    df -i / | awk 'NR==2 {print $4}'
}

# === Gather system info ===
HOSTNAME=$(get_hostname)
IP=$(get_ip)
UPTIME=$(get_uptime)
PACKAGES=$(get_package_count)
CPU_LOAD=$(get_cpu_load)
RAM_USAGE=$(get_ram_usage)
DISK_FREE=$(get_disk_free)
INODES_FREE=$(get_inodes_free)
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# === Logging ===
echo "[$DATE] Hostname: $HOSTNAME | IP: $IP | Uptime: $UPTIME | Packages: $PACKAGES | CPU Load: $CPU_LOAD | RAM Usage: $RAM_USAGE% | Disk Free: $DISK_FREE | Inodes Free: $INODES_FREE" >> "$LOG_FILE"

# === CSV export ===
echo "$HOSTNAME,$IP,$UPTIME,$PACKAGES,$CPU_LOAD,$RAM_USAGE,$DISK_FREE,$INODES_FREE" >> "$CSV_FILE"

# === JSON export ===
cat <<EOF >> "$JSON_FILE"
  {
    "hostname": "$HOSTNAME",
    "ip": "$IP",
    "uptime": "$UPTIME",
    "packages": $PACKAGES,
    "cpu_load": "$CPU_LOAD",
    "ram_usage_percent": "$RAM_USAGE",
    "disk_free": "$DISK_FREE",
    "inodes_free": "$INODES_FREE",
    "date": "$DATE"
  },
EOF

# === Finalize JSON (remove trailing comma and close array) ===

# Remove 2 bytes from the end of the file (the last close array and comma) 
# remove },
truncate -s-2 "$JSON_FILE"
# Close the JSON array
# Add new line \n and ]
echo -e "\n]" >> "$JSON_FILE"
