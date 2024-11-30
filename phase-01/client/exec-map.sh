#!/bin/bash

cd "$(dirname "$0")"
../utils/check-install.sh nmap nmap
../utils/check-install.sh ip ip

# Get the IP address of the client network interface (using the first network interface with an IPv4 address)
CLIENT_IP=$(ip -o -4 addr show | awk '{if ($2 != "lo") print $4}' | head -n 1 | cut -d/ -f1)

# Check if we got a valid IP address
if [ -z "$CLIENT_IP" ]; then
    echo "Error: Could not find a valid network interface."
    exit 1
fi

# Extract the network address (first three octets of the IP address)
NETWORK=$(echo $CLIENT_IP | cut -d. -f1-3)

# Run Nmap scan on the local network
echo "Scanning the network ${NETWORK}.0/24..."
nmap -sn ${NETWORK}.0/24
