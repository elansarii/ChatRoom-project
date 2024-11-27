#!/bin/bash

# server/create-client.sh

create_user() {
    username="$1"
    fullname="$2"

    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
    else
        # Generate password
        password=$(../utils/generate-pass.sh)
        
        # Create user with home directory and full name
        useradd -m -c "$fullname" "$username"

        # Set password for user
        echo -e "$password\n$password" | passwd "$username"

        echo "User '$username' created with password: $password"
    fi

    # Create group 'clients' if it doesn't exist
    if ! getent group clients >/dev/null; then
        groupadd clients
        echo "Group 'clients' created."
    else
        echo "Group 'clients' already exists."
    fi

    # Add user to 'clients' and 'wheel' groups
    usermod -aG clients,wheel "$username"
    echo "User '$username' added to groups 'clients' and 'wheel'."
}

# Check arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <full name>"
    exit 1
fi

username="$1"
fullname="$2"

create_user "$username" "$fullname"

# Call config-site.sh to set up website directory
./config-site.sh "$username"
