#!/bin/bash

source "$(dirname "$0")/../utils/generate-pass.sh"
source "$(dirname "$0")/../utils/check-install.sh"

create_user() {
    local username="$1"
    local fullname="$2"

    local password=$(generate-pass.sh)

    # Check if group exists, create if not
    if ! getent group clients &> /dev/null; then
        su -c "groupadd clients"
    fi

    if ! id "$username" &> /dev/null; then

        su -c "useradd -m -c \"$fullname\" -g clients -G wheel \"$username\""
    fi

    echo -e "$password\n$password" | su -c "passwd $username"

    echo "Username: $username"
    echo "Password: $password"
}

if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <full name>"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

create_user "$1" "$2"
