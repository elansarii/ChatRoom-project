#!/bin/bash
# This script sets up SSH public key authentication by copying the user's public key to a remote server.
# It checks if the public key exists, and if so, copies it using `ssh-copy-id`.

# Change directory to the script's location
cd "$(dirname "$0")"

# Define the path to the server configuration CSV file
SERVER_CSV="../config/server.csv"

# Extract the server IP address from the CSV file (5th column)
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)

# Get the username from the first command-line argument
username=$1

# Define the function to set up SSH public key authentication
setup_auth(){
    # Ensure that the 'ssh-copy-id' utility is installed (check if 'openssh-clients' is installed)
    ../utils/check-install.sh ssh-copy-id openssh-clients >/dev/null 2>&1
    # Suppressing the output here caused bugs on some systems, so the error is not suppressed

    # Attempt to copy the public SSH key to the remote server
    $(ssh-copy-id -i keys/$username.ssh.pub $username@$SERVER_IP)
    
    # Check if the key copy was successful and provide feedback
    if [ $? -eq 0 ]; then
        echo "Public key for user $username successfully copied to server $SERVER_IP"
    else
        echo "An error occurred while trying to copy the public key for username $username to server $SERVER_IP"
    fi
}

# Check if the public key file exists for the user
if ! [ -f "keys/$username.ssh.pub" ]; then
    echo "Please generate an SSH key for $username first using /client/create-keys.sh"
else
    # If the public key exists, proceed to setup authentication
    setup_auth
fi
