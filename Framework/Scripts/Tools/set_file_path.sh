#! /bin/bash
#
# @fatherbrennan

#
# {$1} file path
#
set_file_path()
{
    if [ ! -f "$1" ]
    then
        local a="${1##*/}"
        if [[ "$1" =~ [/] ]]
        then
            local b="${1%/*}/"
            mkdir -p "$b" && touch "${b}${a}" || exit 1
        else
            touch "$a" || exit 1
        fi
    else
        printf '%s' ''>"$1"
    fi
}