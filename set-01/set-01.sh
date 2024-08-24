#!/bin/bash

# Function to display the top 10 most used applications by CPU and memory
show_top_applications() {
  echo "Top 10 Most Used Applications (CPU and Memory):"
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11
  echo
}

# Function to monitor network activity
show_network_monitoring() {
  echo "Network Monitoring:"
  echo "Concurrent Connections: $(netstat -an | grep ESTABLISHED | wc -l)"
  echo "Packet Drops: $(netstat -s | grep 'packet receive errors' | awk '{print $1}')"
  echo "Network Traffic (MB):"
  echo "  Received: $(ifconfig | grep 'RX bytes' | awk '{print $2}' | cut -d: -f2 | awk '{sum+=$1} END {print sum/1048576}') MB"
  echo "  Transmitted: $(ifconfig | grep 'TX bytes' | awk '{print $6}' | cut -d: -f2 | awk '{sum+=$1} END {print sum/1048576}') MB"
  echo
}

# Function to display disk usage
show_disk_usage() {
  echo "Disk Usage:"
  df -h | awk '$5 >= 80 {print $0}' | sed 's/^/WARNING: /'
  df -h | grep -v '^Filesystem' | awk '{print $1 " " $5 " of " $2 " used on " $6}'
  echo
}

# Function to show system load
show_system_load() {
  echo "System Load:"
  uptime | awk '{print "Load Average: " $9, $10, $11}'
  echo "CPU Usage:"
  mpstat | awk '$3 ~ /[0-9.]+/ {print "User: " $3"%", "System: " $5"%", "Idle: " $12"%"}'
  echo
}

# Function to display memory usage
show_memory_usage() {
  echo "Memory Usage:"
  free -m | awk 'NR==2{printf "Total: %s MB\nUsed: %s MB\nFree: %s MB\n", $2, $3, $4}'
  free -m | awk 'NR==3{printf "Swap Total: %s MB\nSwap Used: %s MB\nSwap Free: %s MB\n", $2, $3, $4}'
  echo
}

# Function to show process monitoring
show_process_monitoring() {
  echo "Process Monitoring:"
  echo "Active Processes: $(ps ax | wc -l)"
  echo "Top 5 Processes by CPU and Memory:"
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
  echo
}

# Function to monitor essential services
show_service_monitoring() {
  echo "Service Monitoring:"
  services=("sshd" "nginx" "apache2" "iptables")
  for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
      echo "$service: Active"
    else
      echo "$service: Inactive"
    fi
  done
  echo
}

# Main dashboard function
show_dashboard() {
  clear
  echo "==================== System Dashboard ===================="
  show_top_applications
  show_network_monitoring
  show_disk_usage
  show_system_load
  show_memory_usage
  show_process_monitoring
  show_service_monitoring
  echo "=========================================================="
}

# Parse command-line switches
while [ "$1" != "" ]; do
  case $1 in
    -cpu ) show_system_load; exit;;
    -memory ) show_memory_usage; exit;;
    -network ) show_network_monitoring; exit;;
    -disk ) show_disk_usage; exit;;
    -process ) show_process_monitoring; exit;;
    -service ) show_service_monitoring; exit;;
    -top ) show_top_applications; exit;;
    * ) echo "Invalid option. Available options: -cpu, -memory, -network, -disk, -process, -service, -top"; exit 1
  esac
  shift
done

# If no switches provided, show the full dashboard and refresh every 5 seconds
while true; do
  show_dashboard
  sleep 5
done

