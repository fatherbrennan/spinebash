#! /bin/bash
#
# @fatherbrennan

#
# {$1} any
#
# {return} 0|1
#
is_true()
{
    [ "$1" == "true" ] && return 0 || return 1
}