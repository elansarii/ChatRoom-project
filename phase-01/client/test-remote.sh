#!/bin/bash
cd "$(dirname "$0")"
SERVER_CSV="../config/server.csv"
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)
username=$1
# Install OpenSSH Client
../utils/check-install.sh ssh openssh-client

# Install Mosh
../utils/check-install.sh mosh mosh

# Connect to the ssh server
echo "Testing connectivity to server via ssh"
if [[ $(nc -w 5 "$SERVER_IP" 22 <<< "\0" ) =~ "OpenSSH" ]] ; then
	echo "SSH Connectivity to $SERVER_IP is successful"
else
	echo "SSH Connectivity to $SERVER_IP is failed"
fi


echo "Testing connectivity to server via mosh"
# I don't know how to test mosh properly
if mosh --ssh="ssh -o BatchMode=yes" "$username@$SERVER_IP" --no-init; then
	echo "mosh Connectivity to $SERVER_IP is successful"
else
	echo "mosh Connectivity to $SERVER_IP is failed"
fi
