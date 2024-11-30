#!/bin/bash

cd "$(dirname "$0")"
# Set the server hostname and run other setup scripts
CSV_FILE="config/server.csv"
SERVER_HOSTNAME=$(awk -F',' '{print $4}' $CSV_FILE)
SERVER_IP=$(awk -F',' '{print $5}' $CSV_FILE)

# Set the hostname
echo "Setting hostname to $SERVER_HOSTNAME"
sudo hostnamectl set-hostname $SERVER_HOSTNAME

# Call all setup scripts for the server
echo "Setting up the server..."
./server/config-sshd.sh
./server/config-mosh.sh
./server/config-nginx.sh
./server/create-client.sh
./server/config-site.sh

# Display system information
./utils/fetch-info.sh $SERVER_IP
