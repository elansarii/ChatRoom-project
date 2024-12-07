#!/bin/bash
# This script tests the accessibility of the web server running on the server machine.

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Define the path to the server CSV configuration file and extract the server's IP address
SERVER_CSV="../config/server.csv"
SERVER_IP=$(awk -F',' '{print $5}' $SERVER_CSV)

# Get the username passed as an argument to the script
username=$1

# Check if curl is installed, and install if necessary
../utils/check-install.sh curl curl

# Check if w3m (a text-based web browser) is installed, and install if necessary
../utils/check-install.sh w3m w3m

# Test if the web server is accessible by sending an HTTP request to port 80
if curl -I http://$SERVER_IP:80/ 2>/dev/null | grep -q "200 OK"; then
    # If the web server responds with a "200 OK" HTTP status, print success message
    echo "Web server is accessible. Loading homepage..."
    # Optionally, use w3m to load the homepage in a text-based browser
    w3m http://$SERVER_IP:80/
else
    # If the web server does not respond with "200 OK", print failure message and exit
    echo "Web server is not accessible. Check configuration."
    exit 1
fi
