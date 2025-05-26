#!/bin/bash

LOG_DIR="/var/log/firewall_monitor"
mkdir -p "$LOG_DIR"

DATE=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/iptables_$DATE.log"
JSON_FILE="$LOG_DIR/iptables_$DATE.json"
CSV_FILE="$LOG_DIR/iptables_$DATE.csv"

# === LOG ===
{
    echo "=== IPTABLES STATISTICS ==="
    date
    echo
    iptables -L -v -n --line-numbers
    echo
    echo "=== IPTABLES RAW RULES ==="
    iptables-save
} >> "$LOG_FILE"

# === JSON & CSV Export ===
echo "[" > "$JSON_FILE"
echo "Chain,Policy,Packets,Bytes,Target,Protocol,Opt,In,Out,Source,Destination" > "$CSV_FILE"

iptables -L -v -n --line-numbers | awk '
BEGIN { skip=1 }
/^Chain/ { chain=$2; policy=$4; next }
/^num/ { skip=0; next }
skip==0 && NF >= 10 {
    printf "{\"chain\":\"%s\",\"policy\":\"%s\",\"packets\":\"%s\",\"bytes\":\"%s\",\"target\":\"%s\",\"proto\":\"%s\",\"opt\":\"%s\",\"in\":\"%s\",\"out\":\"%s\",\"source\":\"%s\",\"destination\":\"%s\"},\n", chain, policy, $2, $3, $4, $5, $6, $7, $8, $9, $10
    printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", chain, policy, $2, $3, $4, $5, $6, $7, $8, $9, $10 >> "'"$CSV_FILE"'"
}
' >> "$JSON_FILE"

# Clean trailing comma
truncate -s-2 "$JSON_FILE"
echo -e "\n]" >> "$JSON_FILE"

echo "[OK] IPTABLES log written to $LOG_FILE"
echo "[OK] Exported to $CSV_FILE and $JSON_FILE"
