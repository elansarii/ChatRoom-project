#!/bin/bash
# This script tests connectivity to the server via SSH and Mosh.

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Define the path to the server CSV configuration file and extract the server's IP address
SERVER_CSV="../config/server.csv"
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)

# Get the username passed as an argument to the script
username=$1

# Install OpenSSH Client if it's not already installed
../utils/check-install.sh ssh openssh-client

# Install Mosh if it's not already installed
../utils/check-install.sh mosh mosh

# Test SSH connectivity to the server
echo "Testing connectivity to server via ssh"
# Use netcat (nc) to check if the SSH port (22) is open and responding
if [[ $(nc -w 5 "$SERVER_IP" 22 <<< "\0" ) =~ "OpenSSH" ]] ; then
    # If SSH service is detected, print success message
    echo "SSH Connectivity to $SERVER_IP is successful"
else
    # If SSH service is not detected, print failure message
    echo "SSH Connectivity to $SERVER_IP is failed"
fi

# Test Mosh connectivity to the server
echo "Testing connectivity to server via mosh"
# Use Mosh to attempt a connection with the server using the provided username
# The --no-init option prevents Mosh from attempting to initialize the session (useful for testing)
if mosh --ssh="ssh -o BatchMode=yes" "$username@$SERVER_IP" --no-init; then
    # If Mosh connection is successful, print success message
    echo "Mosh Connectivity to $SERVER_IP is successful"
else
    # If Mosh connection fails, print failure message
    echo "Mosh Connectivity to $SERVER_IP is failed"
fi
