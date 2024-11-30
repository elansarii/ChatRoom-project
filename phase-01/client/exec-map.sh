#!/bin/bash

cd "$(dirname "$0")"
username=$1
../utils/check-install.sh nmap nmap
../utils/check-install.sh ip ip

# Get the IP address of the client
CURRENT_IP=$(hostname -I | awk '{print $1}')

# Check if we got a valid IP address
if [ -z "$CURRENT_IP" ]; then
    echo "Error: Could not find a valid network interface."
    exit 1
fi

# Extract the network address (first three octets of the IP address)
NETWORK=$(echo $CURRENT_IP | cut -d. -f1-3)

# Run Nmap scan on the local network
echo "Scanning the network ${NETWORK}.0/24..."
nmap -sn ${NETWORK}.0/24
