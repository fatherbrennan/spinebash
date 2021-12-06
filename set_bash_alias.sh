#! /bin/bash
# 
# @fatherbrennan
a=".bashrc"
[ -f ~/"$a" ] || touch ~/"$a"
b=$(grep 'alias spine=' ~/"$a" | wc -c)
[ "$b" -gt 0 ] || echo 'alias spine="./spine"'>>~/"$a"
source ~/"$a"
chmod 755 spine Framework/Scripts/* Framework/Scripts/Tools/* Framework/Scripts/Compressors/*
rm -rf set_bash_alias.sh
exit 0