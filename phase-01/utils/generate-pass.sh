#!/bin/bash
cd "$(dirname "$0")"

# Check if pwgen is installed, and install it if not
./check-install.sh pwgen pwgen >/dev/null &2>1

# Generate a 12 character secure password
pwgen -s 12 1
