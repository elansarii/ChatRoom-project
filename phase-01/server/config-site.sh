#!/bin/bash

# server/config-site.sh

# Check for username argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

username="$1"

# Create site directory in user's home if it doesn't exist
if [ ! -d "/home/$username/site" ]; then
    su - "$username" -c "mkdir ~/site"
    echo "Site directory created at /home/$username/site"
else
    echo "Site directory already exists at /home/$username/site"
fi

# Create symbolic link
ln -sfn "/home/$username/site" "/usr/share/nginx/html/$username"
echo "Symbolic link created at /usr/share/nginx/html/$username pointing to /home/$username/site"

# Adjust permissions so NGINX can read user home directories
setfacl -R -m u:nginx:rx "/home/$username"
setfacl -R -m u:nginx:rX "/home/$username/site"

echo "Permissions set to allow NGINX to read /home/$username/site"
