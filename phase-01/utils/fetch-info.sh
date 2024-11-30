#!/bin/bash

# Check if Fastfetch is installed
if ! command -v fastfetch &> /dev/null
then
    echo "Fastfetch is not installed, installing..."
    sudo dnf install -y fastfetch
fi

# Fetch and display system information
echo "Displaying system information..."
fastfetch