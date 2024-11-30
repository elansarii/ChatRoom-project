#!/bin/bash
cd "$(dirname "$0")"
# call the check install script to install sshd if it is not installed
../utils/check-install.sh sshd openssh-server
# Enable server
systemctl enable sshd
# Start server
systemctl start sshd
#Show server status
systemctl status sshd

# Configure sshd_config
sshd_config="/etc/ssh/sshd_config"

sudo sed -i 's/^#Subsystem sftp .*/Subsystem sftp internal-sftp/' "$sshd_config"

# Check if access to ssh is restricted, if not add restiction
if ! sudo grep -q '^AllowGroups clients' "$sshd_config"; then
    echo "AllowGroups clients" | sudo tee -a "$sshd_config"
fi

# Restart sshd service, to apply changes
systemctl restart sshd

# Add firewall rules, and reload to apply changes
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

echo "SSH server configured. Only clients group memeber can access"
