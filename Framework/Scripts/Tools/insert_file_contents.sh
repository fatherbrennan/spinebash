#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'
source "$TOOLS_SET_FILE_PATH"
source "$TOOLS_PRINT_L"

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
    local a=$(sed "/$1/r $3" "$2" | sed "/$1/d")
    if [ -z "$4" ]
    then
        print_l "$a">"$2"
    else
        set_file_path "$4" && print_l "$a">"$4"
    fi
}