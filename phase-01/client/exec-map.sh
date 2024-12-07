#!/bin/bash
# This script scans the local network using Nmap to identify active devices.
# It checks for the installation of required tools and ensures the client is on a valid network.

# Change the working directory to the script's location
cd "$(dirname "$0")"

# Get the username from the first command-line argument
username=$1

# Check and install dependencies (nmap and ip commands) if they are not already installed
../utils/check-install.sh nmap nmap  # Ensures Nmap is installed
../utils/check-install.sh ip ip      # Ensures the IP utility is installed

# Get the current IP address of the machine
CURRENT_IP=$(hostname -I | awk '{print $1}')

# Validate that an IP address was found
if [ -z "$CURRENT_IP" ]; then
    echo "Error: Could not find a valid network interface."
    exit 1  # Exit with error if no valid IP address is detected
fi

# Extract the network address by isolating the first three octets of the IP address
NETWORK=$(echo $CURRENT_IP | cut -d. -f1-3)

# Run an Nmap scan on the local network
echo "Scanning the network ${NETWORK}.0/24..."
nmap -sn ${NETWORK}.0/24  # Perform a ping scan to list active devices on the local network
