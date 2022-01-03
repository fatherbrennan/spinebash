#! /bin/bash
#
# @fatherbrennan
(echo -e '////////////////////////////////////////////////////////////////\n// \n// \n// @fatherbrennan:compressor:js\n//'; cat $1 | sed 's@/\*.*\*/@@g;/\/\*/,/\*\//d;s/\/\/.*//;/^[[:space:]]*$/d' | awk '{$1=$1};1') > $2