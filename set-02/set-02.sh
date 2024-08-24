#!/bin/bash

# secure_audit.sh
# Script to automate security audit and hardening process on Linux servers

# Function to list all users and groups
function audit_users_groups() {
    echo "Listing all users:"
    cut -d: -f1 /etc/passwd

    echo "Listing all groups:"
    cut -d: -f1 /etc/group
}

# Function to check for users with UID 0
function check_uid_0() {
    echo "Checking for non-standard users with UID 0 (root privileges):"
    awk -F: '($3 == 0) {print}' /etc/passwd
}

# Function to scan for world-writable files
function scan_world_writable() {
    echo "Scanning for world-writable files:"
    find / -type f -perm -o+w -exec ls -l {} \;
}

# Function to check SSH directory permissions
function check_ssh_permissions() {
    echo "Checking permissions of .ssh directories:"
    find /home -type d -name ".ssh" -exec chmod 700 {} \;
}

# Function to check for files with SUID or SGID bits set
function check_suid_sgid() {
    echo "Checking for files with SUID/SGID bits set:"
    find / -perm /6000 -type f -exec ls -ld {} \;
}

# Function to list running services
function list_services() {
    echo "Listing all running services:"
    systemctl list-units --type=service --state=running
}

# Function to check firewall status
function check_firewall() {
    echo "Checking firewall status:"
    if systemctl is-active --quiet iptables || systemctl is-active --quiet ufw; then
        echo "Firewall is active"
    else
        echo "Firewall is not active"
    fi
}

# Function to check open ports
function check_open_ports() {
    echo "Checking open ports and associated services:"
    netstat -tulpn | grep LISTEN
}

# Function to check IP forwarding
function check_ip_forwarding() {
    echo "Checking if IP forwarding is enabled:"
    sysctl net.ipv4.ip_forward
}

# Function to check IP addresses
function check_ip_addresses() {
    echo "Identifying public and private IP addresses:"
    ip -o addr show | awk '/inet/ {print $4}'
}

# Function to check for available updates
function check_updates() {
    echo "Checking for available security updates:"
    apt update && apt list --upgradable
}

# Function to check logs for suspicious activity
function check_logs() {
    echo "Checking logs for suspicious activity:"
    grep "Failed password" /var/log/auth.log
}

# Function to harden the server
function harden_server() {
    echo "Implementing server hardening measures:"

    # SSH Configuration
    echo "Configuring SSH..."
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd

    # Disable IPv6
    echo "Disabling IPv6..."
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p

    # Set GRUB bootloader password
    echo "Setting GRUB bootloader password..."
    # Replace GRUB_PASSWORD with your password
    GRUB_PASSWORD=$(echo "GRUB_PASSWORD" | grub-mkpasswd-pbkdf2 | awk '{print $7}')
    echo "set superusers=\"root\"" >> /etc/grub.d/40_custom
    echo "password_pbkdf2 root $GRUB_PASSWORD" >> /etc/grub.d/40_custom
    update-grub
}

# Function to generate report
function generate_report() {
    LOG_FILE="/var/log/secure_audit_report.log"
    echo "Generating security audit report at $LOG_FILE"
    echo "Security Audit Report" > $LOG_FILE
    audit_users_groups >> $LOG_FILE
    check_uid_0 >> $LOG_FILE
    scan_world_writable >> $LOG_FILE
    check_ssh_permissions >> $LOG_FILE
    check_suid_sgid >> $LOG_FILE
    list_services >> $LOG_FILE
    check_firewall >> $LOG_FILE
    check_open_ports >> $LOG_FILE
    check_ip_forwarding >> $LOG_FILE
    check_ip_addresses >> $LOG_FILE
    check_updates >> $LOG_FILE
    check_logs >> $LOG_FILE
}

# Function to send alert via email
function send_alert() {
    LOG_FILE="/var/log/secure_audit_report.log"
    echo "Sending security alert..."
    mail -s "Security Alert" admin@example.com < $LOG_FILE
}

# Main execution
echo "Starting security audit and hardening process..."
audit_users_groups
check_uid_0
scan_world_writable
check_ssh_permissions
check_suid_sgid
list_services
check_firewall
check_open_ports
check_ip_forwarding
check_ip_addresses
check_updates
check_logs
harden_server
generate_report
send_alert

echo "Security audit and hardening process completed!"


