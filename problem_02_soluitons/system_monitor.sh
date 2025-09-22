#!/bin/bash

# Thresholds
cpu_thres=80
mem_thres=80
disk_thres=80
proc_thres=200

# Log file
log_file="/home/venkat/system_health.log"

# Log function
log_alert() {
    local msg="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') -- Alert: $msg" | tee -a "$log_file"
}

# Usage of CPU, MEM, Disk, Processes
cpu_usg=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
cpu_usg=${cpu_usg%.*}

mem_usg=$(free | grep Mem | awk '{print $3/$2 * 100}')
mem_usg=${mem_usg%.*}

disk_usg=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
proc_count=$(ps -e --no-headers | wc -l)

# Checking CPU, MEM, Disk, Processes
if [ $cpu_usg -gt $cpu_thres ]; then
    log_alert "High CPU Usage: ${cpu_usg}%"
fi

if [ $mem_usg -gt $mem_thres ]; then
    log_alert "High Memory Usage: ${mem_usg}%"
fi

if [ $disk_usg -gt $disk_thres ]; then
    log_alert "High Disk Usage in / : ${disk_usg}%"
fi

if [ $proc_count -gt $proc_thres ]; then
    log_alert "High number of processes running: $proc_count"
fi

# Healthy system check
if [ "$cpu_usg" -le "$cpu_thres" ] && \
   [ "$mem_usg" -le "$mem_thres" ] && \
   [ "$disk_usg" -le "$disk_thres" ] && \
   [ "$proc_count" -le "$proc_thres" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - System is healthy." | tee -a "$log_file"
fi

