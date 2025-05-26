#!/bin/bash

# === Configuration ===
SITES_FILE="./sites.txt"
LOG_DIR="./logs"
ARCHIVE_DIR="./archive"
mkdir -p "$LOG_DIR" "$ARCHIVE_DIR"

DATE=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="$LOG_DIR/http_header_log_$DATE.log"
CSV_FILE="$LOG_DIR/http_header_log_$DATE.csv"
JSON_FILE="$LOG_DIR/http_header_log_$DATE.json"

# === Prepare output files ===
echo "Timestamp,Site,Status_Code,Redirect_URL,SSL_Valid,SSL_Expiry_Days" > "$CSV_FILE"
echo "[" > "$JSON_FILE"

check_ssl() {
    local site=$1
    expiry_epoch=$(echo | openssl s_client -servername "$site" -connect "$site:443" 2>/dev/null | \
        openssl x509 -noout -dates 2>/dev/null | grep 'notAfter=' | cut -d= -f2)

    if [[ -z "$expiry_epoch" ]]; then
        echo "NO_CERT,0"
        return
    fi

    expiry_date=$(date -d "$expiry_epoch" +%s)
    now=$(date +%s)
    diff=$(( (expiry_date - now) / 86400 ))

    if (( diff > 0 )); then
        echo "VALID,$diff"
    else
        echo "EXPIRED,0"
    fi
}

while read -r SITE; do
    [[ "$SITE" =~ ^#.*$ || -z "$SITE" ]] && continue

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    HEADERS=$(curl -s -I -L --max-redirs 5 "$SITE")
    STATUS_CODE=$(echo "$HEADERS" | grep HTTP | tail -1 | awk '{print $2}')
    REDIRECT_URL=$(echo "$HEADERS" | grep -i '^location:' | tail -1 | awk '{print $2}' | tr -d '\r')

    if [[ "$SITE" =~ ^https:// ]]; then
        DOMAIN=$(echo "$SITE" | awk -F[/:] '{print $4}')
        read SSL_STATUS SSL_DAYS < <(check_ssl "$DOMAIN")
    else
        SSL_STATUS="N/A"
        SSL_DAYS="N/A"
    fi

    echo "$TIMESTAMP [$SITE] Status: $STATUS_CODE, Redirect: ${REDIRECT_URL:-None}, SSL: $SSL_STATUS ($SSL_DAYS days)" >> "$LOG_FILE"
    echo "$TIMESTAMP,$SITE,$STATUS_CODE,\"${REDIRECT_URL:-None}\",$SSL_STATUS,$SSL_DAYS" >> "$CSV_FILE"
    echo "{\"timestamp\":\"$TIMESTAMP\",\"site\":\"$SITE\",\"status_code\":\"$STATUS_CODE\",\"redirect_url\":\"${REDIRECT_URL:-None}\",\"ssl_status\":\"$SSL_STATUS\",\"ssl_expiry_days\":\"$SSL_DAYS\"}," >> "$JSON_FILE"
done < "$SITES_FILE"

truncate -s-2 "$JSON_FILE"
echo -e "\n]" >> "$JSON_FILE"

# === Archive logs older than 7 days ===
find "$LOG_DIR" -type f -mtime +7 -exec mv {} "$ARCHIVE_DIR/" \;

echo "[OK] Logs saved in $LOG_FILE"
echo "[OK] CSV exported to $CSV_FILE"
echo "[OK] JSON exported to $JSON_FILE"
