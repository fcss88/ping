# 🔄 Auto System Update Script

A Bash script that automatically updates your Linux system using either `apt` (Debian/Ubuntu) or `yum` (RHEL/CentOS), and logs all actions to a file. Perfect for scheduled maintenance, cron jobs, or automated system management.

---

## 📋 Features

- Detects your system's package manager (`apt` or `yum`)
- Runs full system update with logging
- Saves all output (including errors) to a log file
- Automatically creates log directories if missing

---

## 📂 Log Location
/var/log/auto_update/update.log


Each run appends a timestamped entry to the log file.

Example log output:

```
[2025-05-14 23:15:07] Starting APT update...
...
[2025-05-14 23:15:22] APT update and upgrade completed successfully.
```


---

## 🚀 Usage

```bash
chmod +x auto_update.sh
sudo ./auto_update.sh
```


## ⚙️ Compatibility
* ✅ Debian / Ubuntu (APT)
* ✅ CentOS / RHEL (YUM)

Want support for dnf, zypper, or apk? Extend the script easily with additional update_* functions.

## 📌 Notes
The script is safe to run manually or on a schedule.

Logs are stored persistently under /var/log/auto_update/.

You can modify the path at the top of the script if needed.
