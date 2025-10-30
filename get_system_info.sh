#!/bin/bash

# Date & Time Info
CURRENT_DATE=$(date '+%d-%m-%Y')   
CURRENT_TIME=$(date '+%H:%M:%S')   
CURRENT_MONTH=$(date '+%m') 
DAY_OF_WEEK=$(date '+%A') 

USERNAME=$(whoami)
DOMAIN=$(hostname)

echo "Hi, $USERNAME."
echo "$DOMAIN"

echo
echo "-------------------------"
echo "   Current Date & Time   "
echo "-------------------------"
echo "$DAY_OF_WEEK,  $CURRENT_DATE  $CURRENT_TIME"
echo
echo

sleep 2

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE=${CPU_USAGE%.*}

# RAM Info
TOTAL_RAM=$(free -m | awk '/Mem:/ {print $2}')
FREE_RAM=$(free -m | awk '/Mem:/ {print $7}')
USED_RAM=$((TOTAL_RAM - FREE_RAM))

# Disk Info (for /)
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_AVAILABLE=$(df -h / | awk 'NR==2 {print $4}')
DISK_PERCENTAGE=$(df -h / | awk 'NR==2 {print $5}')

# Network status (ping Google DNS)
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    CONNECTION_STATUS="Connected"
else
    CONNECTION_STATUS="Not Connected"
fi

# Network Info
IP_ADDRESS=$(hostname -I | awk '{print $1}')
DEFAULT_GATEWAY=$(ip route | awk '/default/ {print $3}')
SUBNET_MASK=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n1)

# Display System Info
echo "===================================="
echo "        System Information          "
echo "===================================="
echo "CPU Usage:              $CPU_USAGE%"
echo "RAM Usage:              ${USED_RAM} MB / ${TOTAL_RAM} MB (Free: ${FREE_RAM} MB)"
echo "Disk Usage:             $DISK_USED / $DISK_TOTAL (Available: $DISK_AVAILABLE)"
echo "Disk Usage Percentage:  $DISK_PERCENTAGE"
echo "------------------------------------"
echo "Network Configuration:"
echo "Connection Status:      $CONNECTION_STATUS"
echo "IP Address:             $IP_ADDRESS"
echo "Default Gateway:        $DEFAULT_GATEWAY"
echo "Subnet Mask:            $SUBNET_MASK"
echo "===================================="
echo
echo

# Get Public IP
PUBLIC_IP=$(curl -s https://api.ipify.org)

# Get Location Info using ipapi
LOCATION=$(curl -s "https://ipapi.co/$PUBLIC_IP/json")

# Extract location info using jq (ensure jq is installed)
CITY=$(echo "$LOCATION" | jq -r '.city')
REGION=$(echo "$LOCATION" | jq -r '.region')
COUNTRY=$(echo "$LOCATION" | jq -r '.country_name')
POSTAL_CODE=$(echo "$LOCATION" | jq -r '.postal')
LATITUDE=$(echo "$LOCATION" | jq -r '.latitude')
LONGITUDE=$(echo "$LOCATION" | jq -r '.longitude')
ORGANIZATION=$(echo "$LOCATION" | jq -r '.org')

# Show Location Info
echo "------------------------------------"
echo "        System Location Info        "
echo "------------------------------------"
echo "Public IP: $PUBLIC_IP"
echo "City: $CITY"
echo "Region: $REGION"
echo "Country: $COUNTRY"
echo "Postal Code: $POSTAL_CODE"
echo "Latitude: $LATITUDE"
echo "Longitude: $LONGITUDE"
echo "ISP/Organization: $ORGANIZATION"
echo "------------------------------------"
