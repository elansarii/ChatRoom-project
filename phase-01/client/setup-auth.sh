#!/bin/bash
cd  "$(dirname "$0")"
SERVER_CSV="../config/server.csv"
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)
username=$1

setup_auth(){
	../utils/check-install.sh ssh-copy-id openssh-clients >/dev/null &2>1
	#Supressing the output on my machine made some bugs for some reason
	$(ssh-copy-id -i keys/$username.ssh.pub $username@$SERVER_IP)
	if [ $? -eq 0 ]; then
		echo "Public key for user $username successfully copied to server $SERVER_IP"
	else
		echo "An error occured while trying to copy public key for username $username to server $SERVER_IP"
	fi
}

if ! [ -f "keys/$username.ssh.pub" ]; then
	echo "Please generate an ssh key for $username first using /client/create-keys.sh"
else
	setup_auth;
fi
