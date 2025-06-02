#!/bin/bash

FILE="sites.txt"
DATE_NOW=$(date -u +%s)

echo "domain;expiry_date;days_left"

while IFS= read -r domain || [[ -n "$domain" ]]; do
    whois_output=$(whois "$domain")

    # check field for expiry date
    expiry_line=$(echo "$whois_output" | grep -iE 'Expiry Date:|expires:|Expiration Date:' | head -n 1)

    expiry_raw=$(echo "$expiry_line" | cut -d':' -f2- | xargs)

    if [[ -n "$expiry_raw" ]]; then
        parsed_date=""
        # try to unify date -d (timezone Z або +0000)
        parsed_date=$(date -u -d "$expiry_raw" +"%Y-%m-%d %H:%M:%S" 2>/dev/null)

        if [[ $? -eq 0 && -n "$parsed_date" ]]; then
            expiry_ts=$(date -d "$parsed_date" +%s)
            days_left=$(( (expiry_ts - DATE_NOW) / 86400 ))
            echo "$domain;$parsed_date;$days_left"
        else
            echo "$domain;unparsable;-"
        fi
    else
        echo "$domain;not found;-"
    fi
done < "$FILE"
