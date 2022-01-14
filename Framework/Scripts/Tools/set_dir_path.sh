#! /bin/bash
#
# @fatherbrennan

#
# {$1} directory path
#
set_dir_path()
{
    if [ ! -d "$1" ]
    then
            mkdir -p "$1" || exit 1
    fi
}