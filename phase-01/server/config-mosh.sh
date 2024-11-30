#!/bin/bash
cd "$(dirname "$0")"
# Install Mosh
../utils/check-install.sh mosh mosh

# Copy mosh.xml to /etc/firewalld/services/
sudo cp ../config/mosh.xml /etc/firewalld/services/

# Add Mosh service to firewall
sudo firewall-cmd --permanent --add-service=mosh
sudo firewall-cmd --reload

echo "Mosh service installed and firewall configured."
