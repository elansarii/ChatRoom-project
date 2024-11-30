#!/bin/bash
cd "$(dirname "$0")"
# Set up the client based on the CSV file
CSV_FILE="config/clients.csv"
CURRENT_IP=$(hostname -I | awk '{print $1}')
while IFS=',' read -r username fullname email hostname ipaddress
do
  if [ "$ipaddress" == "$CURRENT_IP" ]; then

	  # Set the client hostname
	  echo "Setting hostname for $username to $hostname"
	  sudo hostnamectl set-hostname $hostname

	  # Run all client setup scripts
	  echo "Setting up client $username..."
	  echo "Running test-remote.sh"
	  ./client/test-remote.sh $username
	  echo "Running create-keys.sh"
	  ./client/create-keys.sh $username
	  echo "Running setup-auth.sh"
	  ./client/setup-auth.sh $username
	  echo "Running exec-map.sh"
	  ./client/exec-map.sh $username
	  echo "Running test-web.sh"
	  ./client/test-web.sh $username
	  echo "Running init-site.sh"
	  ./client/init-site.sh $username
	  echo "Running publish-site.sh"
	  ./client/publish-site.sh $username

	  # Display system information
	  echo "Running ./utils/fetch-info.sh"
	  ./utils/fetch-info.sh $ipaddress
	fi
done < "$CSV_FILE"
