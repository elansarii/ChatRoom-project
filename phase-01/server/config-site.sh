#!/bin/bash
# This script sets up the website directory for a given user and configures the necessary symbolic links
# and permissions to allow the NGINX server to serve the user's website.

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Check for the username argument to ensure it is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Set the username variable to the first argument provided to the script
username="$1"

# Check if the site directory already exists in the user's home directory
if [ ! -d "/home/$username/site" ]; then
    # If the site directory doesn't exist, create it
    sudo su - "$username" -c "mkdir ~/site"
    echo "Site directory created at /home/$username/site"
else
    # If the site directory exists, notify the user
    echo "Site directory already exists at /home/$username/site"
fi

# Create a symbolic link in /usr/share/nginx/html/ pointing to the user's site directory
sudo ln -sfn "/home/$username/site" "/usr/share/nginx/html/$username"
echo "Symbolic link created at /usr/share/nginx/html/$username pointing to /home/$username/site"

# Adjust permissions to allow NGINX (user 'nginx') to read the user's home directory and site directory
sudo setfacl -R -m u:nginx:rx "/home/$username"
sudo setfacl -R -m u:nginx:rX "/home/$username/site"

echo "Permissions set to allow NGINX to read /home/$username/site"
