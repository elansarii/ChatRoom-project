#!/bin/bash
# This script automates the setup process for a client system based on a CSV file containing client details.

# Change directory to the script's location
cd "$(dirname "$0")"

# Define the path to the CSV file containing client configuration data
CSV_FILE="config/clients.csv"

# Get the current IP address of the machine
CURRENT_IP=$(hostname -I | awk '{print $1}')

# Read the CSV file line by line
while IFS=',' read -r username fullname email hostname ipaddress
do
  # Check if the current IP matches the IP from the CSV file
  if [ "$ipaddress" == "$CURRENT_IP" ]; then

    # Set the hostname for the current client
    echo "Setting hostname for $username to $hostname"
    sudo hostnamectl set-hostname $hostname

    # Execute various setup scripts for the client
    echo "Setting up client $username..."

    # Run test-remote.sh script for the client
    echo "Running test-remote.sh"
    ./client/test-remote.sh $username

    # Run create-keys.sh script for the client
    echo "Running create-keys.sh"
    ./client/create-keys.sh $username

    # Run setup-auth.sh script for the client
    echo "Running setup-auth.sh"
    ./client/setup-auth.sh $username

    # Run exec-map.sh script for the client
    echo "Running exec-map.sh"
    ./client/exec-map.sh $username

    # Run test-web.sh script for the client
    echo "Running test-web.sh"
    ./client/test-web.sh $username

    # Run init-site.sh script for the client
    echo "Running init-site.sh"
    ./client/init-site.sh $username

    # Run publish-site.sh script for the client
    echo "Running publish-site.sh"
    ./client/publish-site.sh $username

    # Display system information using fetch-info.sh
    echo "Running ./utils/fetch-info.sh"
    ./utils/fetch-info.sh $ipaddress
  fi
done < "$CSV_FILE"
