import subprocess
import re
from datetime import datetime, timezone

def get_whois(domain):
    try:
        result = subprocess.run(['whois', domain], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=10)
        return result.stdout
    except subprocess.TimeoutExpired:
        return ""

def parse_expiry_date(whois_data):
    patterns = [
        r"Registry Expiry Date:\s*(.+)",
        r"Registrar Registration Expiration Date:\s*(.+)",
        r"Expiration Date:\s*(.+)",
        r"expires:\s*(.+)"
    ]

    for pattern in patterns:
        match = re.search(pattern, whois_data, re.IGNORECASE)
        if match:
            return match.group(1).strip()
    return None

import re

def parse_date_string(date_str):
    # Normalize timezone like '+03' → '+0300'
    tz_match = re.search(r"([+-]\d{2})$", date_str)
    if tz_match:
        date_str = date_str.replace(tz_match.group(1), tz_match.group(1) + "00")

    date_formats = [
        "%Y-%m-%dT%H:%M:%SZ",          # 2026-05-03T00:00:00Z
        "%Y-%m-%dT%H:%M:%S%z",         # 2026-05-03T00:00:00+0000
        "%Y-%m-%d %H:%M:%S",           # 2025-07-21 18:00:00
        "%Y-%m-%d %H:%M:%S%z",         # 2025-07-21 18:03:50+03 → +0300
        "%d-%b-%Y",                    # 10-Feb-2028
        "%d-%b-%Y %H:%M:%S",           # 29-Nov-2025 18:19:19
        "%d-%b-%Y %H:%M:%S %Z"         # 29-Nov-2025 18:19:19 UTC
    ]

    for fmt in date_formats:
        try:
            dt = datetime.strptime(date_str, fmt)
            return dt.replace(tzinfo=timezone.utc)
        except ValueError:
            continue
    return None



def main():
    print("domain;expiry_date;days_left")

    try:
        with open("sites.txt", "r") as f:
            domains = [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print("sites.txt not found.")
        return

    now = datetime.now(timezone.utc)

    for domain in domains:
        whois_data = get_whois(domain)
        expiry_str = parse_expiry_date(whois_data)

        if expiry_str:
            expiry_date = parse_date_string(expiry_str)
            if expiry_date:
                days_left = (expiry_date - now).days
                print(f"{domain};{expiry_date.strftime('%Y-%m-%d %H:%M:%S')};{days_left}")
            else:
                print(f"{domain};unparsable;-")
        else:
            print(f"{domain};not found;-")

if __name__ == "__main__":
    main()
