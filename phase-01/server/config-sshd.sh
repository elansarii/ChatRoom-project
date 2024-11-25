#!/bin/bash

# Install OpenSSH server
../utils/check-install.sh sshd openssh-server

# Enable and start sshd service
systemctl enable sshd
systemctl start sshd
systemctl status sshd

# Configure sshd_config
sshd_config="/etc/ssh/sshd_config"

sed -i 's/^#Subsystem sftp .*/Subsystem sftp internal-sftp/' "$sshd_config"

# Restrict SSH access to 'clients' group
if ! grep -q '^AllowGroups clients' "$sshd_config"; then
    echo "AllowGroups clients" | tee -a "$sshd_config"
fi

# Restart sshd service
systemctl restart sshd

# Add firewall rules
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

echo "SSH server configured to allow access only to 'clients' group."
