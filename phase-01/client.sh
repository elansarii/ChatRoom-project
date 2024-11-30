#!/bin/bash

# Set up the client based on the CSV file
CSV_FILE="config/clients.csv"
while IFS=',' read -r username fullname email hostname ipaddress
do
  # Set the client hostname
  echo "Setting hostname for $username to $hostname"
  sudo hostnamectl set-hostname $hostname

  # Run all client setup scripts
  echo "Setting up client $username..."
  ./client/test-remote.sh
  ./client/create-keys.sh
  ./client/setup-auth.sh
  ./client/exec-map.sh
  ./client/test-web.sh
  ./client/init-site.sh
  ./client/publish-site.sh

  # Display system information
  ./utils/fetch-info.sh $ipaddress
done < "$CSV_FILE"