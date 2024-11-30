#!/bin/bash

cd "$(dirname "$0")"

SERVER_CSV="../config/server.csv"
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)
username=$1
#Check that curl is installed
./utils/check-install.sh curl curl
#Check thhat w3m is installed
./utils/check-install.sh w3m w3m


#Check if web server is accessible ny client
if curl -I http://$SERVER_IP:80/ 2>dev/null | grep -q "200 OK"; then
	echo "Web server is accessible. Loading homepage..."
else 
	echo "Web server is not accessible. Check configuration."
	exit 1
fi
