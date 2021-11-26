#! /bin/bash
# 
# @fatherbrennan
a=".bashrc"
[ -f ~/"$a" ] || touch ~/"$a"
echo 'alias spine="./spine"'>>~/"$a"
source ~/"$a"
rm -rf set_bash_alias.sh
exit 0