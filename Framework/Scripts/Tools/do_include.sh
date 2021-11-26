#! /bin/bash
# 
# @fatherbrennan
do_include()
{
    # Check if the file exists
    [ -f "$1" ] || return 1
    # Check if the file is not empty
    [ -s "$1" ] && return 0 || return 1
}