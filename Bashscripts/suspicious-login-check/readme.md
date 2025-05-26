# 🔐 Suspicious Login Analyzer (Linux Auth Log)

A Bash script that analyzes system authentication logs for suspicious login activity. It automatically detects your Linux distribution (Debian/Ubuntu or CentOS/RHEL) and processes the appropriate system log file (`auth.log` or `secure`).

---

## 📋 Features

- Auto-detects the Linux distribution
- Parses failed login attempts (`Failed password`)
- Detects top offending IP addresses
- Shows successful external logins (non-localhost)
- Logs the analysis results to a persistent file
---
## 🗂️ Log Sources (Auto-detected)

- Debian / Ubuntu → `/var/log/auth.log`
- CentOS / RHEL → `/var/log/secure`
---

## 📂 Output Log
All results are saved to: ```/var/log/suspicious_logins/report.log```

### Example Output:
```
[2025-05-14 23:52:33] === Suspicious Login Check Started ===
[2025-05-14 23:52:33] Analyzing file: /var/log/auth.log
[2025-05-14 23:52:33] Failed login attempts:
5 May 14 22:21:15 192.168.1.50
3 May 14 21:05:32 92.123.34.12
[2025-05-14 23:52:33] Top offending IPs:
5 192.168.1.50
3 92.123.34.12
[2025-05-14 23:52:33] Successful external logins:
May 14 21:00:12 203.0.113.99
[2025-05-14 23:52:33] === Check Completed ===
```

---

## 🚀 Usage

```bash
chmod +x suspicious_login_check.sh
sudo ./suspicious_login_check.sh
```
🔑 Root access is required to read system log files.

### 🔁 Automation with Cron
To run the analysis daily, add to crontab:

```sudo crontab -e```

Then add:


```0 2 * * * /path/to/suspicious_login_check.sh```

## 📌 Requirements

+ Access to system logs

+ Works on most modern Linux distributions