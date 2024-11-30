#!/bin/bash
cd "$(dirname "$0")"


./check-install.sh pwgen pwgen >/dev/null &2>1

# Generate a 12 char password
pwgen -s 12 1
