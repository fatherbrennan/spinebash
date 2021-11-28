#! /bin/bash
# 
# @fatherbrennan
a=".bashrc"
[ -f ~/"$a" ] || touch ~/"$a"
b=$(grep 'alias spine=' ~/"$a" | wc -c)
[ "$b" -gt 0 ] || echo 'alias spine="./spine"'>>~/"$a"
source ~/"$a"
rm -rf set_bash_alias.sh
exit 0
