#! /bin/bash
# 
# @fatherbrennan
(echo -e '/**\n * \n * \n * @fatherbrennan@CSScompressor\n */'; cat $1 | sed 's@/\*.*\*/@@g;/\/\*/,/\*\//d;s/[[:blank:]]*/ /' | tr -d '\n' | tr -s ' ' ' ' | sed 's/ {/{/g;s/{ /{/g;s/} /}/g;s/ }/}/g;s/: /:/g;s/ :/:/g;s/; /;/g;s/ ;/;/g;s/, /,/g;s/ ,/,/g;s/^ *//') > $2