#!/bin/bash
# This script installs and configures the SSH server (OpenSSH) on the machine,
# ensuring only members of the "clients" group can access it.
# It also sets up the internal SFTP subsystem and configures firewall rules.

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Call the check-install script to install OpenSSH server (if it's not already installed)
../utils/check-install.sh sshd openssh-server

# Enable the SSH service to start on boot
systemctl enable sshd

# Start the SSH service
systemctl start sshd

# Display the status of the SSH service to confirm it's running
systemctl status sshd

# Define the location of the sshd_config file
sshd_config="/etc/ssh/sshd_config"

# Modify the sshd_config file to configure the internal SFTP subsystem
# Replace the default "Subsystem sftp" line with "Subsystem sftp internal-sftp"
sudo sed -i 's/^#Subsystem sftp .*/Subsystem sftp internal-sftp/' "$sshd_config"

# Check if the "AllowGroups clients" directive is present in sshd_config
# If not, add it to ensure only members of the "clients" group can access SSH
if ! sudo grep -q '^AllowGroups clients' "$sshd_config"; then
    echo "AllowGroups clients" | sudo tee -a "$sshd_config"
fi

# Restart the SSH service to apply the changes made to sshd_config
systemctl restart sshd

# Add firewall rules to allow SSH access and reload the firewall to apply the changes
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

# Output message to confirm SSH server configuration
echo "SSH server configured. Only members of the 'clients' group can access."
