#!/bin/bash

# Configuration
CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90
EMAIL="admin@example.com"
LOG_FILE="/var/log/system_monitor.log"

# Logging function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Alert sending function
send_alert() {
    local subject="$1"
    local message="$2"
    
    # Send via email (mail needs to be configured)
    echo "$message" | mail -s "$subject" "$EMAIL" 2>/dev/null
    
    # Can also add Slack/Telegram integration
    log_message "ALERT: $subject - $message"
}

# CPU check
check_cpu() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
    cpu_usage=${cpu_usage%.*} # Round to integer
    
    if [[ $cpu_usage -gt $CPU_THRESHOLD ]]; then
        send_alert "HIGH CPU Usage Alert" "CPU usage is ${cpu_usage}% (threshold: ${CPU_THRESHOLD}%)"
        return 1
    fi
    
    log_message "CPU usage: ${cpu_usage}% - OK"
    return 0
}

# Memory check
check_memory() {
    local memory_info=$(free | grep Mem)
    local total=$(echo $memory_info | awk '{print $2}')
    local used=$(echo $memory_info | awk '{print $3}')
    local memory_usage=$((used * 100 / total))
    
    if [[ $memory_usage -gt $MEMORY_THRESHOLD ]]; then
        send_alert "HIGH Memory Usage Alert" "Memory usage is ${memory_usage}% (threshold: ${MEMORY_THRESHOLD}%)"
        return 1
    fi
    
    log_message "Memory usage: ${memory_usage}% - OK"
    return 0
}

# Disk space check
check_disk() {
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [[ $disk_usage -gt $DISK_THRESHOLD ]]; then
        send_alert "HIGH Disk Usage Alert" "Disk usage is ${disk_usage}% (threshold: ${DISK_THRESHOLD}%)"
        return 1
    fi
    
    log_message "Disk usage: ${disk_usage}% - OK"
    return 0
}

# Main function
main() {
    log_message "Starting system monitoring check..."
    
    local alerts=0
    
    check_cpu || ((alerts++))
    check_memory || ((alerts++))
    check_disk || ((alerts++))
    
    if [[ $alerts -eq 0 ]]; then
        log_message "All system resources are within normal limits"
    else
        log_message "System monitoring completed with $alerts alert(s)"
    fi
}

# Script execution
main "$@"