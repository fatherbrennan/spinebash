#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'

find "$PUBLIC_DIR" -type f -delete
find "$CACHE_DIR" -type f -delete