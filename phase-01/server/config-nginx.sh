#!/bin/bash
# This script installs and configures NGINX, enables and starts the NGINX service,
# adds necessary firewall rules, and tests the server's functionality using cURL.

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Install NGINX if it is not already installed
../utils/check-install.sh nginx nginx

# Enable the NGINX service to start on boot and start the service
sudo systemctl enable nginx
sudo systemctl start nginx

# Display the status of the NGINX service to ensure it is running
sudo systemctl status nginx

# Add firewall rules to allow HTTP traffic (port 80)
sudo firewall-cmd --permanent --add-service=http

# Reload the firewall to apply the changes
sudo firewall-cmd --reload

# Test the NGINX server by sending an HTTP request to the localhost
output=$(curl -I http://localhost)

# Display the result of the test
echo "Testing NGINX server:"
echo "$output"
