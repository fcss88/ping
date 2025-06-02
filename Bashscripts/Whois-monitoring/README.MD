# Domain Expiry Monitor

This project contains two scripts — one in **Bash** and one in **Python** — that check the expiration dates of domain names. The scripts read a list of domains from `sites.txt`, use the `whois` service to retrieve domain data, extract the expiration dates, and output the results in a standardized format:
```
domain;expiry_date;days_left
example.com;2025-10-10 12:00:00;500
```

---

## 📁 File Structure
```
.
├── sites.txt # List of domains to check
├── check_domains.sh # Bash script
├── check_domains.py # Python script
└── README.md # This documentation
```

---

## 🧾 `sites.txt` Format

The `sites.txt` file is a plain text file containing one domain per line:
```
ukr.net
fcss88.pp.ua
google.ua
microsoft.com
```

---

## 🛠 Bash Script (`check_domains.sh`)

### 🔧 Requirements

- `whois`
- `date`
- `grep`, `awk`, `sed` (standard Unix text processing tools)

### ▶️ How to Run

```
chmod +x check_domains.sh
./check_domains.sh
```



### ⚙️ How It Works
1. Reads domains line by line from sites.txt.

2. Runs whois for each domain.

Filters output to find expiration-related fields using keywords such as:

- Registry Expiry Date

- Expiration Date

- expires:

3. Attempts to parse the expiration date from common date formats:

- YYYY-MM-DD

- DD-MM-YYYY

- YYYY-MM-DD HH:MM:SS TZ

4. Calculates how many days remain until expiration (compared to current UTC date).

5. Prints the result in CSV-like format:
```
domain;expiry_date;days_left
```

❗ Note: Because WHOIS outputs vary significantly between TLDs (.com, .ua, .pp.ua, etc.), some dates might not be parsable and appear as unparsable;-.

## 🐍 Python Script (check_domains.py)
### 🔧 Requirements
- Python 3.6 or newer

- No external packages needed

Uses only standard Python libraries: subprocess, datetime, re

### ▶️ How to Run
```python3 check_domains.py```

### ⚙️ How It Works
1. Reads the list of domains from sites.txt.

2. For each domain:

- Executes a whois query using subprocess.

- Searches for expiration-related fields in the output using regular expressions.

- Normalizes timezones like +03 to +0300 if needed.

- Tries multiple date formats to parse expiration dates reliably.

- Calculates days remaining by comparing the parsed expiration date to current UTC time.

3. Displays output in this format:

```
domain;expiry_date;days_left
```


### 🧠 Logic Highlights

WHOIS inconsistencies: Different registrars and TLDs use different field names and date formats. This tool handles the most common ones, but not all.

Multiple date formats supported: ISO 8601 (YYYY-MM-DDTHH:MM:SSZ), UTC-based formats, DD-MM-YYYY, etc.

Timezone normalization: Dates like 2025-07-21 18:03:50+03 are auto-normalized to parse correctly.

***Graceful fallback: If the date cannot be parsed, the tool outputs ```unparsable;-.```***

### ✅ Example Output
```
domain;expiry_date;days_left
ukr.net;2028-02-10 05:00:00;983
fcss88.pp.ua;2025-11-29 18:19:19;180
google.ua;2025-07-21 15:03:50;49
microsoft.com;2026-05-03 04:00:00;335
```