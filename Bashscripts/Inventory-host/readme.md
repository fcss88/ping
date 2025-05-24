# 🖥️ Server Inventory Script

A simple Bash script that collects detailed information about a Linux server and exports it to **log**, **CSV**, and **JSON** formats. Useful for system administrators, DevOps, or anyone managing multiple servers.

*The script requires root or sudo privileges to access system info reliably.*

---

## 📋 Features

- Hostname and IP address detection
- System uptime
- Installed package count (supports `dpkg` and `rpm`)
- CPU load average (1 min)
- RAM usage (percentage)
- Available disk space
- Available inodes
- Exports to:
  - Human-readable log file
  - CSV (for spreadsheets)
  - JSON (for APIs or automation)

---

## 📂 Output Files

By default, all output is stored in: **/var/log/inventory/**
- `inventory.log` — human-readable log
- `inventory.csv` — comma-separated values
- `inventory.json` — structured JSON array

---

## 🚀 Usage

```
chmod +x inventory.sh
sudo ./inventory.sh
```


## 🛠 Requirements
Linux system with Bash

### Utilities:

- df, free, awk, hostname, uptime

- dpkg or rpm (depending on distro)


## 📦 Sample Output
### ✅ Log file

```
[2025-05-14 22:38:07] Hostname: myserver | IP: 192.168.1.10 | Uptime: 3 hours | Packages: 842 | CPU Load: 0.15 | RAM Usage: 43.27% | Disk Free: 12G | Inodes Free: 842114
```

### ✅ CSV
```
hostname,ip,uptime,packages,cpu_load,ram_usage,disk_free,inodes_free
myserver,192.168.1.10,3 hours,842,0.15,43.27,12G,842114
```
### ✅ JSON
```
[
  {
    "hostname": "myserver",
    "ip": "192.168.1.10",
    "uptime": "3 hours",
    "packages": 842,
    "cpu_load": "0.15",
    "ram_usage_percent": "43.27",
    "disk_free": "12G",
    "inodes_free": "842114",
    "date": "2025-05-14 22:38:07"
  }
]
```

## 🔒 Permissions
Make sure the script can write to ```/var/log/inventory/```. You can modify the paths at the top of the script if needed.


## 📌 Notes
+ This script is designed for single-server diagnostics. For fleet-wide scanning, consider pairing it with SSH or automation tools like Ansible.

+ Ideal for homelabs, small servers, standalone machines or internal system reporting.
