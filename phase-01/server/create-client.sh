#!/bin/bash
cd "$(dirname "$0")"
# server/create-client.sh
# This script creates a new user with a home directory, a secure password, and adds the user to specific groups.
# It also ensures that the 'clients' group exists and adds the new user to it.

create_user() {
    # Function to create a new user with a full name and assign necessary configurations
    username="$1"
    fullname="$2"

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
    else
        # Generate a random password using the generate-pass.sh script
        password=$(../utils/generate-pass.sh)
        
        # Create the user with a home directory and full name
        sudo useradd -m -c "$fullname" "$username"

        # Set the password for the user (password is set twice for confirmation)
        echo -e "$password\n$password" | passwd "$username"

        echo "User '$username' created with password: $password"
    fi

    # Create the 'clients' group if it doesn't already exist
    if ! getent group clients >/dev/null; then
        sudo groupadd clients
        echo "Group 'clients' created."
    else
        echo "Group 'clients' already exists."
    fi

    # Add the user to the 'clients' and 'wheel' groups for elevated privileges
    sudo usermod -aG clients,wheel "$username"
    echo "User '$username' added to groups 'clients' and 'wheel'."
}

# Check if the correct number of arguments were provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <full name>"
    exit 1
fi

# Set the username and full name from the arguments passed to the script
username="$1"
fullname="$2"

# Call the create_user function to create the user and assign groups
create_user "$username" "$fullname"

# Call the config-site.sh script to set up the website directory for the new user
./config-site.sh "$username"
