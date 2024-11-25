#!/bin/bash

check_install() {
    local command="$1"
    local package="$2"

    if ! command -v "$command" &> /dev/null; then
        echo "Installing $package to provide $command..."

        if command -v dnf &> /dev/null; then
            su -c "dnf install -y $package"
        else
            echo "You are using an unsupported package manager, Use (dnf) please"
            exit 1
        fi
    fi
}

check_install "$1" "$2"
