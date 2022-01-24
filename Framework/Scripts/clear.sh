#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'

# Remove all directories and contents except src/
for d in $(find "$PUBLIC_DIR"* -maxdepth 0 -type d ! -name src); do rm -rf "$d"; done
# Remove top level files
find "$PUBLIC_DIR"* -maxdepth 0 -type f -delete
find "$CACHE_DIR" -type f -delete