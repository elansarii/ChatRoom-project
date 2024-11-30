#!/bin/bash

# Check if Hugo is installed
./utils/check-install.sh hugo hugo

# Check if rsync is installed
./utils/check-install.sh rsync rsync

# Define variables
SERVER_CSV="../config/server.csv"
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)
username=$1
SITE_DIR=/home/$username/site
REMOTE_SITE_DIR=/home/$username/site

# Ensure the site directory exists
if [ ! -d "$SITE_DIR" ]; then
    echo "Error: Site directory $SITE_DIR does not exist. Please initialize the site first."
    exit 1
fi

# Build the Hugo site
echo "Building the Hugo site..."
hugo -s "$SITE_DIR"

# Synchronize the site with the remote server
echo "Synchronizing site content with the server..."
rsync -avz --delete "$SITE_DIR/public/" "$username@$SERVER_IP:$REMOTE_SITE_DIR"

echo "Site published successfully. You can verify it at http://$SERVER_IP/client/"