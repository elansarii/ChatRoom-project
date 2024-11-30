#!/bin/bash

# Check if Hugo is installed
./utils/check-install.sh hugo hugo

# Check if rsync is installed
./utils/check-install.sh rsync rsync

# Define variables
SITE_DIR=~/site
REMOTE_USER=username
REMOTE_SERVER=serverip
REMOTE_SITE_DIR=/home/$REMOTE_USER/site

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
rsync -avz --delete "$SITE_DIR/public/" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_SITE_DIR"

echo "Site published successfully. You can verify it at http://$REMOTE_SERVER/client/"
