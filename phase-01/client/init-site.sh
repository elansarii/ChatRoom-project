#!/bin/bash
# This script initializes a new Hugo site for a client, setting up the site directory,
# initializing a Git repository, and configuring a theme.

# Change to the directory of the script
cd "$(dirname "$0")"

# Check if Hugo is installed, and install it if necessary
./utils/check-install.sh hugo hugo

# Get the username from the first command-line argument
username=$1

# Define the path to the site directory
SITE_DIR=/home/$username/site

# Check if the site directory already exists
if [ -d "$SITE_DIR" ]; then
    # If the site directory exists, print a message and exit
    echo "Site directory already exists. Skipping initialization."
    exit 0
fi

# Create a new Hugo site in the specified directory
echo "Creating a new Hugo site at $SITE_DIR..."
hugo new site "$SITE_DIR"

# Change to the newly created site directory
cd "$SITE_DIR"

# Initialize a new Git repository in the site directory
echo "Initializing a Git repository..."
git init

# Add a Hugo theme as a Git submodule
echo "Adding Hugo theme as a Git submodule..."
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke

# Configure the theme in Hugo by adding the theme name to the config.toml file
echo "Configuring the theme in Hugo..."
echo "theme = 'ananke'" >> config.toml

# Print success message
echo "Hugo site initialized successfully at $SITE_DIR."
