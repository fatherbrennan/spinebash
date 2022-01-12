#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'
source "$TOOLS_SET_FILE_PATH"

#
# {$1} placeholder [ RegEx pattern ]
# {$2} input file [ template file containing the placeholder ]
# {$3} content [ file in which contents is to be inserted ]
# ?{$4} output file [ file path in which to output : if null, input file is used ]
#
# Usage: insert_file_contents '{{ wrap }}' 'wrapper' 'content_to_wrap' 'new/path/file.txt'
#
insert_file_contents()
{
    local a=$(sed "/$1/r $3" "$2" | sed "s/$1//")
    if [ -z "$4" ]
    then
        printf '%s' "$a">"$2"
    else
        set_file_path "$4" && printf '%s' "$a">"$4"
    fi
}