#! /bin/bash
# 
# @fatherbrennan
is_true()
{
    [ "$1" == "true" ] && return 0 || return 1
}