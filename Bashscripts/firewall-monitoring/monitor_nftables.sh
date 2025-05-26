#!/bin/bash

LOG_DIR="/var/log/firewall_monitor"
mkdir -p "$LOG_DIR"

DATE=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/nftables_$DATE.log"
JSON_FILE="$LOG_DIR/nftables_$DATE.json"
CSV_FILE="$LOG_DIR/nftables_$DATE.csv"

# === LOG ===
{
    echo "=== NFTABLES STATISTICS ==="
    date
    echo
    nft list ruleset
} >> "$LOG_FILE"

# === Parse statistics from rules ===
echo "[" > "$JSON_FILE"
echo "Table,Chain,Handle,Packets,Bytes,Rule" > "$CSV_FILE"

nft -a list ruleset | awk '
BEGIN { table=""; chain="" }
/^table/ { table=$2 }
/^chain/ { chain=$2 }
/handle/ {
    split($0, a, "handle")
    rule=a[1]; gsub("\"", "", rule)
    handle=a[2]
    match($0, /packets ([0-9]+) bytes ([0-9]+)/, m)
    packets=m[1]; bytes=m[2]
    printf "{\"table\":\"%s\",\"chain\":\"%s\",\"handle\":\"%s\",\"packets\":\"%s\",\"bytes\":\"%s\",\"rule\":\"%s\"},\n", table, chain, handle, packets, bytes, rule >> "'"$JSON_FILE"'"
    printf "%s,%s,%s,%s,%s,%s\n", table, chain, handle, packets, bytes, rule >> "'"$CSV_FILE"'"
}
'

truncate -s-2 "$JSON_FILE"
echo -e "\n]" >> "$JSON_FILE"

echo "[OK] NFTABLES log written to $LOG_FILE"
echo "[OK] Exported to $CSV_FILE and $JSON_FILE"
