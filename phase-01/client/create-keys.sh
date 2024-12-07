#!/bin/bash
# This script generates SSH keys for a specified username.
# If a key already exists for the user, it does not regenerate the key.

# Change the working directory to the script's location
cd "$(dirname "$0")"

# Get the username from the first command-line argument
username=$1

# Define the function to create SSH keys
create_keys() {
    # Prompt the user to enter a password for the SSH key
    read -p "Enter the password for the SSH key (Empty for auto generated): " password </dev/tty
    
    # If no password is provided, generate one automatically
    if [ -z "$password" ]; then
        password=$(../utils/generate-pass.sh) # Call the generate-pass.sh script to create a random password
        echo "The generated password is: '$password' (PLEASE COPY IT)"
    fi

    # Generate the SSH key using the provided or generated password
    echo "Generating an SSH key"
    ssh-keygen -t ed25519 -N "$password" -C "$username" -f keys/$username.ssh >/dev/null;

    # Display the generated public key
    echo "The public key generated is:"
    cat ./keys/$username.ssh.pub

    # Display the generated private key
    echo "The private key generated is:"
    cat ./keys/$username.ssh
}

# Check if an SSH key already exists for the user
if cat ./keys/$username.ssh >/dev/null 2>&1; then
    # If a key exists, inform the user
    echo "The user already has a key"
else
    # If no key exists, call the create_keys function to generate one
    create_keys
fi
