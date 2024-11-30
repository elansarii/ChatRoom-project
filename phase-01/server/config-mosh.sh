#!/bin/bash
cd "$(dirname "$0")"
# Install Mosh
../utils/check-install.sh mosh mosh

# Copy mosh.xml to /etc/firewalld/services/
cp ../config/mosh.xml /etc/firewalld/services/

# Add Mosh service to firewall
firewall-cmd --permanent --add-service=mosh
firewall-cmd --reload

echo "Mosh service installed and firewall configured."
