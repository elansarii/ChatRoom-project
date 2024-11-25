#!/bin/sh

# utils/check-install.sh

if [ $# -ne 2 ]; then
    echo "Usage: $0 <command> <package>"
    exit 1
fi

command="$1"
package="$2"

if ! command -v "$command" >/dev/null 2>&1; then
    echo "Command '$command' not found. Installing package '$package'."
    dnf install -y "$package"
else
    echo "Command '$command' is already installed."
fi
