#!/bin/sh

# utils/generate-pass.sh

./check-install.sh pwgen pwgen

# Generate and print a secure password
pwgen -s 12 1
