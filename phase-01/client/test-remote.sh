#!/bin/bash

# Install OpenSSH Client
../utils/check-install.sh ssh openssh-client

# Install Mosh
../utils/check-install.sh mosh mosh

# Connect to the ssh server
ip_address=$(grep 'server_ip=' ../config.conf | sed 's/^.*\=//')

ssh_output=$(ssh -F /dev/null -l $USER $ip_address)
echo "Testing connectivity to server via ssh"
echo "$ssh_output"

mosh_output=$(mosh $ip_address)
echo "Testing connectivity to server via mosh"
echo "$mosh_output"
