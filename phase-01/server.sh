#!/bin/bash
# This script automates the server setup process based on a CSV file containing server and client details.

# Change directory to the script's location
cd "$(dirname "$0")"

# Define the path to the server configuration CSV file
CSV_FILE="config/server.csv"

# Extract the server hostname from the CSV file (4th column)
SERVER_HOSTNAME=$(awk -F',' '{print $4}' $CSV_FILE)

# Extract the server IP address from the CSV file (5th column)
SERVER_IP=$(awk -F',' '{print $5}' $CSV_FILE)

# Define the path to the clients configuration CSV file
CLIENTS_CSV="config/clients.csv"

# Set the server's hostname
echo "Setting hostname to $SERVER_HOSTNAME"
sudo hostnamectl set-hostname $SERVER_HOSTNAME

# Run all necessary setup scripts for the server
echo "Setting up the server..."

# Configure SSH daemon settings
./server/config-sshd.sh

# Configure MOSH (mobile shell) settings
./server/config-mosh.sh

# Configure the NGINX web server
./server/config-nginx.sh

# Loop through the clients CSV file and execute create-client.sh for each client
awk -F, '{ system("./server/create-client.sh \"" $1 "\" \"" $2 "\""); }' "$CLIENTS_CSV"

# Display system information for the server
./utils/fetch-info.sh $SERVER_IP
