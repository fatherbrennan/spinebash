#! /bin/bash
#
# @fatherbrennan

#
# {$1} string
#
print_l()
{
    printf "%s\n" "$1" && return 0 || return 1
}