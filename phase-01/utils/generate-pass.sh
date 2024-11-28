#!/bin/bash
cd "$(dirname "$0")"

# utils/generate-pass.sh

./check-install.sh pwgen pwgen >/dev/null &2>1

# Generate and print a secure password
pwgen -s 12 1
