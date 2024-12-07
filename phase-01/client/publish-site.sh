#!/bin/bash
# This script builds the Hugo site on the client machine and synchronizes it with the remote server using rsync.

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Check if Hugo is installed, and install it if necessary
../utils/check-install.sh hugo hugo

# Check if rsync is installed, and install it if necessary
../utils/check-install.sh rsync rsync

# Define necessary variables
SERVER_CSV="../config/server.csv"
# Extract the server IP from the server CSV configuration file (5th column)
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)

# Get the username passed as an argument to the script
username=$1

# Define the site directory on the local machine and the corresponding directory on the remote server
SITE_DIR=/home/$username/site
REMOTE_SITE_DIR=/home/$username/site

# Ensure the site directory exists on the local machine
if [ ! -d "$SITE_DIR" ]; then
    # If the site directory does not exist, display an error and exit
    echo "Error: Site directory $SITE_DIR does not exist. Please initialize the site first."
    exit 1
fi

# Build the Hugo site to generate the static files
echo "Building the Hugo site..."
hugo -s "$SITE_DIR"

# Synchronize the generated site content with the remote server using rsync
echo "Synchronizing site content with the server..."
rsync -avz --delete "$SITE_DIR/public/" "$username@$SERVER_IP:$REMOTE_SITE_DIR"

# Print a success message with the URL to verify the site on the server
echo "Site published successfully. You can verify it at http://$SERVER_IP/client/"
