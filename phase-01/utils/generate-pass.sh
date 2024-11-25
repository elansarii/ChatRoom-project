#!/bin/bash

source "$(dirname "$0")/check-install.sh"

check_install pwgen pwgen

pwgen -s 16 1
