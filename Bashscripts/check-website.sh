#!/bin/bash
# need install bc
# need install curl
# config
URL="https://fcss88.pp.ua/"
LOG_FILE="website_monitor.log"
THRESHOLD=2.0

# current time
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# work with website
response=$(curl -s -w "%{http_code} %{time_total}" -o /tmp/site_check_output.html "$URL")
HTTP_CODE=$(echo "$response" | awk '{print $1}')
LOAD_TIME=$(echo "$response" | awk '{print $2}')

# get headers
HEADERS=$(curl -s -I "$URL")

# create log
{
  echo "=== [$DATE] check website ==="
  echo "URL: $URL"
  echo "HTTP-code: $HTTP_CODE"
  echo "Load time: ${LOAD_TIME}s"
  if (( $(echo "$LOAD_TIME > $THRESHOLD" | bc -l) )); then
    echo "Attention: slow answer (over ${THRESHOLD}s)"
  fi
  if [[ "$HTTP_CODE" -ne 200 ]]; then
    echo "❌ Error! Website return code $HTTP_CODE"
  fi
  echo "--- Answer headers ---"
  echo "$HEADERS"
  echo ""
} > "$LOG_FILE"
exit 0