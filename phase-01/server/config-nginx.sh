#!/bin/bash
cd "$(dirname "$0")"
# server/config-nginx.sh

# Install NGINX
../utils/check-install.sh nginx nginx

# Enable and start nginx service
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

# Add firewall rules
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

# Test server with cURL
output=$(curl -I http://localhost)

echo "Testing NGINX server:"
echo "$output"
