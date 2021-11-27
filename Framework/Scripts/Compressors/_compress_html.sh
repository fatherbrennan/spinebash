#! /bin/bash
# 
# @fatherbrennan
(echo -e '<!--\n - \n - \n - @fatherbrennan@HTMLcompressor\n -->'; cat $1 | sed 's@/\*.*\*/@@g;/\/\*/,/\*\//d' | tr -d '\n' | tr -s ' ' ' ' | sed 's/ {/{/g;s/{ /{/g;s/} /}/g;s/ }/}/g;s/: /:/g;s/ :/:/g;s/; /;/g;s/ ;/;/g;s/, /,/g;s/ ,/,/g;s/> />/g;s/ </</g') > $2