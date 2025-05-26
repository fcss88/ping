# 🔥 Firewall Monitoring Scripts

This folder contains three Bash scripts to monitor the status and statistics of different firewall systems: **iptables**, **nftables**, and **ufw**.

Each script:
- Logs firewall rule and packet statistics to a `.log` file
- Exports parsed data to `.json` and `.csv` formats
- Automatically creates a structured log folder at `/var/log/firewall_monitor`

## Scripts

| Script | Description |
|--------|-------------|
| `monitor_iptables.sh` | Gathers verbose iptables rules and statistics |
| `monitor_nftables.sh` | Extracts complete nftables ruleset with counters |
| `monitor_ufw.sh`      | Reads UFW status and logs recent rule matches from system logs |

## Output files

Each script creates three files per run:
- `*.log` — raw logs
- `*.csv` — structured tabular data
- `*.json` — structured data for integration

## Example Usage

```bash
chmod +x monitor_*.sh
./monitor_iptables.sh
./monitor_nftables.sh
./monitor_ufw.sh
```

## Automation (cron)

To run these scripts daily:

```cron
@daily /path/to/monitor_iptables.sh
@daily /path/to/monitor_nftables.sh
@daily /path/to/monitor_ufw.sh
```