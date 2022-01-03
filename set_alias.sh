#! /bin/bash
#
# @fatherbrennan
a=".bashrc"
b=".zshrc"
add()
{
    [ -f ~/"$1" ] || touch ~/"$1"
    d=$(grep 'alias spine=' ~/"$1" | wc -c)
    [ "$d" -gt 0 ] || echo 'alias spine="./spine"'>>~/"$1"
    source ~/"$1"
}
add "$a"
c=$(ps | grep zsh | wc -c)
echo "$c"
[ "$c" -gt 0  ] && add "$b"
chmod 700 spine Framework/Scripts/* Framework/Scripts/Tools/* Framework/Scripts/Compressors/*
rm -rf set_alias.sh
exit 0