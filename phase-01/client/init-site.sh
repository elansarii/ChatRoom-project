#!/bin/bash

cd "$(dirname "$0")"
# Check if Hugo is installed
./utils/check-install.sh hugo hugo

# Define the site directory
SITE_DIR=~/site

# Check if the site directory already exists
if [ -d "$SITE_DIR" ]; then
    echo "Site directory already exists. Skipping initialization."
    exit 0
fi

# Create a new Hugo site
echo "Creating a new Hugo site at $SITE_DIR..."
hugo new site "$SITE_DIR"

# Navigate to the site directory
cd "$SITE_DIR"

# Initialize a Git repository
echo "Initializing a Git repository..."
git init

# Add a theme as a Git submodule
echo "Adding Hugo theme as a Git submodule..."
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke

# Configure the theme in Hugo
echo "Configuring the theme in Hugo..."
echo "theme = 'ananke'" >> config.toml
echo "Hugo site initialized successfully at $SITE_DIR."
