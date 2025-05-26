# **AutoBan Users & IPs (iptables version)**

This script automatically monitors failed SSH login attempts, locks user accounts after repeated failures, and blocks the source IP addresses using `iptables`.

## 🔧 Features

- Monitors `/var/log/auth.log` or `/var/log/secure` (Debian/CentOS support)
- Locks Unix users after repeated failed login attempts
- Bans IP addresses using a dedicated `iptables` chain
- Automatically unbans users and IPs after a defined timeout
- Logs all actions to a dedicated log file

## ⚙️ Configuration

Inside the script:

```bash
MAX_ATTEMPTS=5                  # Number of failed attempts before banning
BAN_DURATION_MINUTES=15         # How long to ban user/IP
BAN_FILE="/var/log/auto_ban/banlist.txt"
LOG_FILE="/var/log/auto_ban/ban.log"
IPTABLES_CHAIN="AUTO_BAN"
```
## 📄 How it works
1. Scans auth.log for failed logins.

2. If a user exceeds the threshold:

* Locks the user account (usermod -L)

* Blocks the source IP via iptables -I AUTO_BAN -s IP -j DROP

3. Unbans users/IPs after timeout using timestamps stored in ```banlist.txt```

## 📌 Notes
Script must be run as root.

Adds a dedicated iptables chain: ```AUTO_BAN```

Adds this chain to the ```INPUT``` chain.

## ⏱️ Suggested Cron Job
```*/5 * * * * /path/to/auto_ban_users.sh```


##📂 Log Files
+ Action log: ```/var/log/auto_ban/ban.log```

+ Ban state: ```/var/log/auto_ban/banlist.txt```


# 🔒 **AutoBan Users & IPs via nftables**


## AutoBan Users & IPs (nftables version)

This script scans system authentication logs for failed SSH login attempts. It automatically locks Unix users and bans suspicious IP addresses using `nftables`.

## 🔧 Features

- Works on both Debian and CentOS systems
- Locks user accounts after repeated failures
- Uses `nftables` to block IP addresses for a limited time
- Dynamically creates table, set, and chain for isolated firewall control
- Logs every action to a log file

## ⚙️ Configuration

Set within the script:

```bash
MAX_ATTEMPTS=5
BAN_DURATION_MINUTES=15
NFT_TABLE="inet"
NFT_SET="auto_ban_ips"
NFT_CHAIN="input"
BAN_FILE="/var/log/auto_ban/banlist_nft.txt"
LOG_FILE="/var/log/auto_ban/ban.log"
```

## 📄 How it works
Parses ```/var/log/auth.log or /var/log/secure```

If a user fails login more than ```MAX_ATTEMPTS```: 
Locks the user account via usermod -L

Bans their IP with nft add element inet filter ```auto_ban_ips``` { IP timeout 15m }

Unlocks users after ban time.

IPs are auto-unbanned by nftables due to the timeout flag.

## 🧱 nftables Structure

The script creates:

+ Table: inet filter

+ Set: auto_ban_ips (with timeout support)

+ Chain: input, with rule to drop IPs from the set

## 📌 Notes
Requires root privileges.

Automatically initializes nftables setup if not already created.

## ⏱️ Suggested Cron Job
*/5 * * * * /path/to/auto_ban_users_nft.sh

## 📂 Log Files
+ Action log: ```/var/log/auto_ban/ban.log```

+ Ban state: ```/var/log/auto_ban/banlist_nft.txt```

## ✅ Requirements
nftables must be installed and enabled:


```
sudo apt install nftables     # Debian/Ubuntu
sudo systemctl enable nftables
sudo systemctl start nftables
```
