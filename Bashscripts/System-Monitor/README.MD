# System Monitor Script

A comprehensive bash script for monitoring system resources (CPU, Memory, Disk) with configurable thresholds and automated alerting capabilities.

## Overview

The `system_monitor.sh` script continuously monitors critical system resources and sends alerts when usage exceeds predefined thresholds. It's designed for production environments where proactive monitoring is essential for maintaining system stability.

## Features

- **CPU Usage Monitoring**: Tracks CPU utilization percentage
- **Memory Usage Monitoring**: Monitors RAM consumption
- **Disk Space Monitoring**: Checks available disk space on root partition
- **Email Alerts**: Sends notifications when thresholds are exceeded
- **Detailed Logging**: Maintains comprehensive logs of all monitoring activities
- **Configurable Thresholds**: Easy to customize warning levels
- **Exit Codes**: Returns appropriate exit codes for integration with monitoring systems

## Prerequisites

### System Requirements
- Linux/Unix operating system
- Bash shell (version 4.0 or higher)
- Standard utilities: `top`, `free`, `df`, `awk`, `grep`

### Email Configuration (Optional)
For email alerts to work, you need a configured mail system:
```bash
# Install mailutils (Ubuntu/Debian)
sudo apt-get install mailutils

# Or postfix (CentOS/RHEL)
sudo yum install postfix
```

## Installation

1. **Download the script:**
```bash
wget 
# or
curl -O 
```

2. **Make it executable:**
```bash
chmod +x system_monitor.sh
```

3. **Create log directory (if needed):**
```bash
sudo mkdir -p /var/log
sudo touch /var/log/system_monitor.log
sudo chown $(whoami):$(whoami) /var/log/system_monitor.log
```

## Configuration

### Threshold Settings

Edit the script to modify monitoring thresholds:

```bash
# Configuration section at the top of the script
CPU_THRESHOLD=80        # CPU usage percentage (default: 80%)
MEMORY_THRESHOLD=85     # Memory usage percentage (default: 85%)
DISK_THRESHOLD=90       # Disk usage percentage (default: 90%)
EMAIL="admin@example.com"  # Email for alerts
LOG_FILE="/var/log/system_monitor.log"  # Log file path
```

### Recommended Threshold Values

| Resource | Conservative | Standard | Aggressive |
|----------|-------------|----------|------------|
| CPU      | 70%         | 80%      | 90%        |
| Memory   | 75%         | 85%      | 95%        |
| Disk     | 80%         | 90%      | 95%        |

## Usage

### Manual Execution

```bash
# Run single check
./system_monitor.sh

# Run with verbose output
./system_monitor.sh 2>&1 | tee -a manual_check.log
```

### Automated Monitoring

#### Crontab Setup
Add to your crontab for regular monitoring:

```bash
# Edit crontab
crontab -e

# Add these entries:
# Check every 5 minutes
*/5 * * * * /path/to/system_monitor.sh

# Check every hour during business hours
0 9-17 * * 1-5 /path/to/system_monitor.sh

# Daily summary at midnight
0 0 * * * /path/to/system_monitor.sh
```

#### Systemd Service (Advanced)

Create a systemd service for continuous monitoring:

```bash
# Create service file
sudo nano /etc/systemd/system/system-monitor.service
```

```ini
[Unit]
Description=System Resource Monitor
After=network.target

[Service]
Type=simple
ExecStart=/path/to/system_monitor.sh
Restart=always
RestartSec=300
User=monitoring
Group=monitoring

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start service
sudo systemctl enable system-monitor.service
sudo systemctl start system-monitor.service
```

## Output Examples

### Normal Operation
```
[2024-06-07 14:30:15] Starting system monitoring check...
[2024-06-07 14:30:15] CPU usage: 45% - OK
[2024-06-07 14:30:15] Memory usage: 72% - OK
[2024-06-07 14:30:15] Disk usage: 68% - OK
[2024-06-07 14:30:15] All system resources are within normal limits
```

### Alert Condition
```
[2024-06-07 14:35:20] Starting system monitoring check...
[2024-06-07 14:35:20] ALERT: HIGH CPU Usage Alert - CPU usage is 85% (threshold: 80%)
[2024-06-07 14:35:20] Memory usage: 78% - OK
[2024-06-07 14:35:20] Disk usage: 71% - OK
[2024-06-07 14:35:20] System monitoring completed with 1 alert(s)
```

## Exit Codes

The script returns specific exit codes for integration with monitoring systems:

| Exit Code | Meaning |
|-----------|---------|
| 0 | All resources within normal limits |
| 1 | One or more alerts triggered |

## Log File Management

### Log Rotation

Set up logrotate to manage log file size:

```bash
# Create logrotate config
sudo nano /etc/logrotate.d/system-monitor
```

```
/var/log/system_monitor.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 monitoring monitoring
}
```

### Log Analysis

```bash
# View recent alerts
grep "ALERT" /var/log/system_monitor.log | tail -10

# Count alerts by type
grep "HIGH CPU" /var/log/system_monitor.log | wc -l
grep "HIGH Memory" /var/log/system_monitor.log | wc -l
grep "HIGH Disk" /var/log/system_monitor.log | wc -l

# Show statistics for last 24 hours
grep "$(date '+%Y-%m-%d')" /var/log/system_monitor.log
```

## Integration with Monitoring Systems

### Nagios Integration

```bash
# Nagios command definition
define command {
    command_name    check_system_resources
    command_line    /path/to/system_monitor.sh
}

# Service definition
define service {
    use                     generic-service
    host_name               localhost
    service_description     System Resources
    check_command           check_system_resources
    check_interval          5
}
```

### Zabbix Integration

```bash
# Zabbix UserParameter
UserParameter=system.monitor,/path/to/system_monitor.sh
```

### Prometheus Integration

Create a simple exporter wrapper:

```bash
#!/bin/bash
# prometheus_wrapper.sh
./system_monitor.sh
echo "system_monitor_exit_code $?" > /var/lib/prometheus/node_exporter/system_monitor.prom
```

## Troubleshooting

### Common Issues

#### 1. Permission Denied
```bash
# Make script executable
chmod +x system_monitor.sh

# Check log file permissions
ls -la /var/log/system_monitor.log
```

#### 2. Mail Not Working
```bash
# Test mail configuration
echo "Test message" | mail -s "Test" your@email.com

# Check mail logs
sudo tail -f /var/log/mail.log
```

#### 3. CPU Reading Issues
```bash
# Test CPU reading manually
top -bn1 | grep "Cpu(s)"

# Alternative CPU check
cat /proc/loadavg
```

### Debug Mode

Add debug output to the script:

```bash
# Add after #!/bin/bash
set -x  # Enable debug mode
set -e  # Exit on error
```

## Customization

### Adding New Metrics

To monitor additional resources, add new functions:

```bash
# Example: Network interface monitoring
check_network() {
    local interface="eth0"
    local rx_bytes=$(cat /sys/class/net/$interface/statistics/rx_bytes)
    local tx_bytes=$(cat /sys/class/net/$interface/statistics/tx_bytes)
    
    log_message "Network $interface: RX=$rx_bytes, TX=$tx_bytes"
}
```

### Custom Alert Methods

Add Slack integration:

```bash
send_slack_alert() {
    local message="$1"
    local webhook_url="YOUR_SLACK_WEBHOOK"
    
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"$message\"}" \
        "$webhook_url"
}
```

## Security Considerations

- Run with minimal privileges (avoid root when possible)
- Secure log files with appropriate permissions
- Use secure channels for alert notifications
- Regularly review and update email configurations
- Consider using encrypted communication for alerts

## Performance Impact

The script is designed to be lightweight:
- **CPU Impact**: < 1% during execution
- **Memory Usage**: < 10MB
- **Execution Time**: Typically 1-3 seconds
- **I/O Impact**: Minimal (only log writes)

## Contributing

To contribute improvements:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Update documentation
5. Submit a pull request

## License

This script is released under the MIT License. See LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check existing documentation
- Review troubleshooting section

## Changelog

### Version 1.0
- Initial release
- Basic CPU, Memory, Disk monitoring
- Email alerting
- Configurable thresholds