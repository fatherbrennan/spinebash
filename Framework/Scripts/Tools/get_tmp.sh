#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'
source "$TOOLS_SET_FILE_PATH"

#
# {return} temp file path
#
get_tmp()
{
    local a="Framework/Scripts/cache/tmp/.tmp${RANDOM}"
    set_file_path "$a" && printf '%s' "$a"
}