<<<<<<< Updated upstream
#!/bin/bash
cd "$(dirname "$0")"
# utils/check-install.sh

=======
#!/bin/sh

#make sure that there are two arguments passed
>>>>>>> Stashed changes
if [ $# -ne 2 ]; then
    echo "Wrong input. Expected input: $0 <command> <package>"
    exit 1
fi

command="$1"
package="$2"

#Check if the command is installed, if not install the package
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
