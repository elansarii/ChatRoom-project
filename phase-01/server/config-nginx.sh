#!/bin/bash

# server/config-nginx.sh

# Install NGINX
../utils/check-install.sh nginx nginx

# Enable and start nginx service
systemctl enable nginx
systemctl start nginx
systemctl status nginx

# Add firewall rules
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Test server with cURL
curl_output=$(curl -I http://localhost)

echo "Testing NGINX server:"
echo "$curl_output"
