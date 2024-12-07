#!/bin/bash
# This script installs Mosh, configures the firewall to allow Mosh traffic, 
# and copies the necessary configuration to the firewalld service directory.

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Install Mosh if it is not already installed
../utils/check-install.sh mosh mosh

# Copy the Mosh configuration file (mosh.xml) to the firewalld services directory
sudo cp ../config/mosh.xml /etc/firewalld/services/

# Add Mosh service to the firewall configuration permanently
sudo firewall-cmd --permanent --add-service=mosh

# Reload the firewall to apply the new configuration
sudo firewall-cmd --reload

# Confirm the installation and firewall configuration
echo "Mosh service installed and firewall configured."
