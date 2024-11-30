#!/bin/bash
cd  "$(dirname "$0")"

ip_address=$(grep 'server_ip=' ../config.conf | sed 's/^.*\=//')

setup_auth(){
	../utils/check-install.sh ssh-copy-id openssh-clients >/dev/null &2>1
	#Supressing the output on my machine made some bugs for some reason
	ssh-copy-id -i keys/$USER.ssh.pub $USER@$ip_address
	if [ $? -eq 0 ]; then
		echo "Public key for user $USER successfully copied to server $ip_address"
	else
		echo "An error occured while trying to copy public key for user $USER to server $ip_address"
	fi
}

if ! file keys/$USER.ssh.pub >/dev/null 2>&1; then
	echo "Please generate an ssh key for $USER first using /client/create-keys.sh"
else
	setup_auth;
fi
