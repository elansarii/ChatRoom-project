#!/bin/bash
cd "$(dirname "$0")"
create_keys() {
#read -p "Enter the password for the ssh key (Empty for auto generated): " password
if [ -z "$password" ]; then
		password=$(../utils/generate-pass.sh)
		echo "The generated password is: '$password' (PLEASE COPY IT)"
fi

	echo "Generating an ssh key"
	ssh-keygen -t ed25519 -N "$password" -C "$USER" -f keys/$USER.ssh >/dev/null;
	echo "The public key generated is:"
	cat ./keys/$USER.ssh.pub

	echo "The private key generated is:"
	cat ./keys/$USER.ssh
}

if cat ./keys/$USER.ssh >/dev/null 2>&1; then
	echo "The user already has a key"
else
	create_keys
fi	
