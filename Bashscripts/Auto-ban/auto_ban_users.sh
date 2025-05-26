#!/bin/bash

# === Config ===
AUTH_LOG="/var/log/auth.log"
[ -f /etc/redhat-release ] && AUTH_LOG="/var/log/secure"

BAN_FILE="/var/log/auto_ban/banlist.txt"
LOG_FILE="/var/log/auto_ban/ban.log"
MAX_ATTEMPTS=5
BAN_DURATION_MINUTES=15
IPTABLES_CHAIN="AUTO_BAN"

mkdir -p "$(dirname "$BAN_FILE")"

# === Functions ===
log() {
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

ban_ip() {
    local ip=$1
    if ! iptables -L "$IPTABLES_CHAIN" -n | grep -q "$ip"; then
        iptables -I "$IPTABLES_CHAIN" -s "$ip" -j DROP
        log "IP address '$ip' has been banned via iptables."
    fi
}

unban_ip() {
    local ip=$1
    iptables -D "$IPTABLES_CHAIN" -s "$ip" -j DROP 2>/dev/null
    log "IP address '$ip' has been unbanned."
}

# === Ensure iptables chain exists ===
if ! iptables -L "$IPTABLES_CHAIN" -n &>/dev/null; then
    iptables -N "$IPTABLES_CHAIN"
    iptables -I INPUT -j "$IPTABLES_CHAIN"
fi

# === Step 1: Parse Failed Logins ===
log "Scanning for failed logins..."

# Extract IP and user from failed logins
grep "Failed password" "$AUTH_LOG" | awk '{print $(NF), $(NF-3)}' | sort | uniq -c | while read COUNT USER IP; do
    if [[ "$COUNT" -ge "$MAX_ATTEMPTS" ]]; then
        # Ban user
        if id "$USER" &>/dev/null && ! grep -q "^$USER:" "$BAN_FILE"; then
            usermod -L "$USER"
            log "User '$USER' has been locked."
        fi

        # Ban IP
        ban_ip "$IP"

        # Store ban time
        echo "$USER:$IP:$(date +%s)" >> "$BAN_FILE"
    fi
done

# === Step 2: Unban users and IPs ===
TEMP_FILE=$(mktemp)

while IFS=: read -r USER IP BANTIME; do
    NOW=$(date +%s)
    ELAPSED=$(( (NOW - BANTIME) / 60 ))

    if [ "$ELAPSED" -ge "$BAN_DURATION_MINUTES" ]; then
        usermod -U "$USER" 2>/dev/null && log "User '$USER' has been unlocked."
        unban_ip "$IP"
    else
        echo "$USER:$IP:$BANTIME" >> "$TEMP_FILE"
    fi
done < "$BAN_FILE"

mv "$TEMP_FILE" "$BAN_FILE"