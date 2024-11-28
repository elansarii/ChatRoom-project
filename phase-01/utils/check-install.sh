#!/bin/bash
cd "$(dirname "$0")"
# utils/check-install.sh

if [ $# -ne 2 ]; then
    echo "Usage: $0 <command> <package>"
    exit 1
fi

command="$1"
package="$2"

if ! command -v "$command" >/dev/null 2>&1; then
    echo "Command '$command' not found. Installing package '$package'."
    sudo dnf install -y "$package" >/dev/null
	if [ $? -eq 0 ]; then
		echo "Installation Successful"
	else
		echo "Installation Failed"
	fi
else
    echo "Command '$command' is already installed."
fi
