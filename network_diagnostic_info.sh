#!/bin/bash

# Function to check internet speed
check_internet_speed() {
    echo "========================================="
    echo "      Checking Internet Speed...         "
    echo "========================================="
    if command -v speedtest >/dev/null 2>&1; then
        speedtest
    else
        echo "Error: 'speedtest' not found. Install it using 'sudo apt install speedtest-cli'"
    fi
    echo
}

# Function to trace routes
trace_routes() {
    echo "========================================="
    echo "        Tracing Route to Server          "
    echo "========================================="
    read -p "Enter a domain to trace (default: google.com): " DOMAIN
    DOMAIN=${DOMAIN:-google.com}
    if command -v traceroute >/dev/null 2>&1; then
        echo "Tracing route to $DOMAIN..."
        traceroute -m 10 "$DOMAIN" | awk '{print "Hop " NR ": " $0}'
    else
        echo "Error: 'traceroute' not found. Install it using 'sudo apt install traceroute'"
    fi
    echo
}

# Function to ping a server with advanced options
ping_server() {
    echo "========================================="
    echo "        Advanced Ping Utility            "
    echo "========================================="
    read -p "Enter a server to ping (default: 8.8.8.8): " SERVER
    SERVER=${SERVER:-8.8.8.8}
    read -p "Number of packets to send (default: 4): " PACKETS
    PACKETS=${PACKETS:-4}
    read -p "Packet size in bytes (default: 32): " PACKET_SIZE
    PACKET_SIZE=${PACKET_SIZE:-32}

    PAYLOAD_SIZE=$((PACKET_SIZE - 8))
    if [ "$PAYLOAD_SIZE" -lt 0 ]; then
        echo "Error: Packet size must be at least 8 bytes to account for ICMP header."
        return
    fi

    if command -v ping >/dev/null 2>&1; then
        ping -c $PACKETS -s $PAYLOAD_SIZE $SERVER
    else
        echo "Error: ping command not found. Ensure your system allows ICMP requests."
    fi
    echo
}

# Function to show detailed network configuration
network_configuration() {
    echo "========================================="
    echo "        Network Configuration            "
    echo "========================================="

    if command -v ip >/dev/null 2>&1; then
        IP_ADDRESS=$(hostname -I | awk '{print $1}')
        DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
        DNS_SERVER=$(systemd-resolve --status 2>/dev/null | grep "DNS Servers" | awk '{print $3}' | head -n 1)

        echo "IP Address:           $IP_ADDRESS"
        echo "Default Gateway:      $DEFAULT_GATEWAY"
        echo "DNS Server:           $DNS_SERVER"
    else
        echo "Error: 'ip' command not found."
    fi
    echo
}

# Function to perform port scanning
port_scanning() {
    echo "========================================="
    echo "           Fast Port Scanning            "
    echo "========================================="
    read -p "Enter a domain or IP to scan (default: localhost): " HOST
    HOST=${HOST:-localhost}
    read -p "Enter port range to scan (e.g., 1-1000): " PORT_RANGE

    START_PORT=$(echo $PORT_RANGE | cut -d'-' -f1)
    END_PORT=$(echo $PORT_RANGE | cut -d'-' -f2)

    echo "Scanning ports on $HOST from $START_PORT to $END_PORT..."
    echo

    MAX_PROCESSES=50
    CURRENT_PROCESSES=0

    for PORT in $(seq $START_PORT $END_PORT); do
        (timeout 1 bash -c "echo >/dev/tcp/$HOST/$PORT") 2>/dev/null && echo "Port $PORT is open" &
        ((CURRENT_PROCESSES++))
        if ((CURRENT_PROCESSES >= MAX_PROCESSES)); then
            wait -n
            ((CURRENT_PROCESSES--))
        fi
    done

    wait
    echo
    echo "Port scan completed!"
    echo
}

# Feature 5: Live Packet Capture
live_packet_capture() {
    echo "========================================="
    echo "     Capturing 10 Packets on Interface   "
    echo "========================================="
    read -p "Enter network interface (default: eth0): " INTERFACE
    INTERFACE=${INTERFACE:-eth0}
    if command -v tcpdump >/dev/null 2>&1; then
        echo "Capturing packets on $INTERFACE..."
        sudo tcpdump -n -i "$INTERFACE" -c 10 2>/dev/null | awk '{print NR ". " $0}'
    else
        echo "Error: 'tcpdump' not found. Install it using 'sudo apt install tcpdump'"
    fi
    echo
}

# Feature 8: Show Bandwidth Usage
bandwidth_usage() {
    echo "========================================="
    echo "     Bandwidth Usage for Interfaces      "
    echo "========================================="
    if command -v vnstat >/dev/null 2>&1; then
        vnstat --oneline | while IFS=';' read -r IFACE _ RX TX _; do
            echo "Interface: $IFACE"
            echo "  RX: $RX"
            echo "  TX: $TX"
            echo
        done
    else
        echo "vnstat not found. Using system counters..."
        printf "%-10s %-15s %-15s\n" "Interface" "Received(Bytes)" "Transmitted(Bytes)"
        awk 'NR>2 {
            iface = $1; sub(":", "", iface);
            rx = $2; tx = $10;
            printf "%-10s %-15s %-15s\n", iface, rx, tx;
        }' /proc/net/dev
    fi
    echo
}

# Feature 10: Check for Open WiFi Networks Nearby
scan_wifi_networks() {
    echo "========================================="
    echo "     Nearby WiFi Networks & Security     "
    echo "========================================="
    if command -v nmcli >/dev/null 2>&1; then
        echo "Scanning WiFi networks..."
        echo
        nmcli -t -f SSID,SECURITY,SIGNAL dev wifi | sort -t: -k3 -nr | while IFS=: read -r SSID SECURITY SIGNAL; do
            SECURITY_STATUS="Secured 🔐"
            [ -z "$SECURITY" ] && SECURITY_STATUS="Open 🔓"
            printf "📶  %-30s | %s | Signal: %s%%\n" "$SSID" "$SECURITY_STATUS" "$SIGNAL"
        done
    else
        echo "Error: 'nmcli' not found. Install it using 'sudo apt install network-manager'"
    fi
    echo
}

# Function to log diagnostic results
log_results() {
    echo "Saving results to 'network_advance_diagnostic.log'..."
    {
        echo "========================================="
        echo "   Network Diagnostic Results Log        "
        echo "   Date: $(date)"
        echo "========================================="
        check_internet_speed
        trace_routes
        ping_server
        network_configuration
    } >> network_advance_diagnostic.log
    echo "Results saved."
    echo
}

# Main menu
while true; do
    echo "========================================="
    echo "    Advanced Network Diagnostic Tool     "
    echo "========================================="
    echo "1.  Check Internet Speed"
    echo "2.  Trace Route to a Server"
    echo "3.  Ping a Server (Advanced)"
    echo "4.  Show Network Configuration Details"
    echo "5.  Perform Port Scanning"
    echo "6.  Log Diagnostic Results"
    echo "7.  Live Packet Capture (tcpdump)"
    echo "8.  Show Bandwidth Usage per Interface"
    echo "9.  Scan Nearby WiFi Networks"
    echo "10. Exit"
    echo "========================================="
    read -p "Choose an option (1-10): " OPTION

    case $OPTION in
        1) check_internet_speed ;;
        2) trace_routes ;;
        3) ping_server ;;
        4) network_configuration ;;
        5) port_scanning ;;
        6) log_results ;;
        7) live_packet_capture ;;
        8) bandwidth_usage ;;
        9) scan_wifi_networks ;;
        10) echo "Exiting..."; break ;;
        *) echo "Invalid option. Please choose again."; echo ;;
    esac
done
