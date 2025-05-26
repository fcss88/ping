#!/bin/bash

# === Config ===
AUTH_LOG="/var/log/auth.log"
[ -f /etc/redhat-release ] && AUTH_LOG="/var/log/secure"

BAN_FILE="/var/log/auto_ban/banlist_nft.txt"
LOG_FILE="/var/log/auto_ban/ban.log"
MAX_ATTEMPTS=5
BAN_DURATION_MINUTES=15
NFT_TABLE="inet"
NFT_SET="auto_ban_ips"
NFT_CHAIN="input"

mkdir -p "$(dirname "$BAN_FILE")"

log() {
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

# === Ensure nftables set exists ===
if ! nft list set $NFT_TABLE filter $NFT_SET &>/dev/null; then
    nft add table $NFT_TABLE
    nft add set $NFT_TABLE filter $NFT_SET '{ type ipv4_addr; flags timeout; }'
    nft add chain $NFT_TABLE filter $NFT_CHAIN '{ type filter hook input priority 0; }'
    nft add rule $NFT_TABLE filter $NFT_CHAIN ip saddr @${NFT_SET} drop
    log "Created nftables table, set, and rule for banning IPs."
fi

ban_ip() {
    local ip=$1
    if ! nft list set $NFT_TABLE filter $NFT_SET | grep -q "$ip"; then
        nft add element $NFT_TABLE filter $NFT_SET "{ $ip timeout ${BAN_DURATION_MINUTES}m }"
        log "IP address '$ip' has been banned via nftables for $BAN_DURATION_MINUTES minutes."
    fi
}

# === Step 1: Parse Failed Logins ===
log "Scanning for failed logins..."

grep "Failed password" "$AUTH_LOG" | awk '{print $(NF), $(NF-3)}' | sort | uniq -c | while read COUNT USER IP; do
    if [[ "$COUNT" -ge "$MAX_ATTEMPTS" ]]; then
        if id "$USER" &>/dev/null && ! grep -q "^$USER:" "$BAN_FILE"; then
            usermod -L "$USER"
            log "User '$USER' has been locked."
        fi

        ban_ip "$IP"
        echo "$USER:$IP:$(date +%s)" >> "$BAN_FILE"
    fi
done

# === Step 2: Unban users ===
TEMP_FILE=$(mktemp)

while IFS=: read -r USER IP BANTIME; do
    NOW=$(date +%s)
    ELAPSED=$(( (NOW - BANTIME) / 60 ))

    if [ "$ELAPSED" -ge "$BAN_DURATION_MINUTES" ]; then
        usermod -U "$USER" 2>/dev/null && log "User '$USER' has been unlocked."
    else
        echo "$USER:$IP:$BANTIME" >> "$TEMP_FILE"
    fi
done < "$BAN_FILE"

mv "$TEMP_FILE" "$BAN_FILE"