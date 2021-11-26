#! /bin/bash
# 
# @fatherbrennan

res1=$(date +%s.%N)

# Get relative path from arg
app=$1

# Track asset files
assets=""

# Run build scripts
"${app}Framework/Scripts/_get_routes.sh" || exit 1
"${app}Framework/Scripts/_make_css.sh" || exit 1
"${app}Framework/Scripts/_make_js.sh" || exit 1
"${app}Framework/Scripts/_make_markup.sh" || exit 1

# Print
print_box()
{
    local a=("$@")
    local b=$(tput cols)-2
    p(){ echo -ne "${2}\e[2m${1}\e[0m"; }
    p "\u250c";for ((i=0;i<$b;i++));do p "\u2500";done;p "\u2510"
    for i in "${a[@]}";do local d=$(($b-${#i}-1));p "\u2502";printf %"$d"s; p "\u2502" "\e[32m${i}\e[0m ";done
    p "\u2514";for ((i=0;i<$b;i++));do p "\u2500";done;p "\u2518"
}

# Loop through all asset files
for f in $(find "${app}Public/" -type f)
do
    # Track assets relative path
    assets+="$(echo "$f" | sed "s#$app##")\n"
done

# Print assets
if [ ! -z "$assets" ]
then
    res2=$(date +%s.%N)
    echo -ne "\n\e[32m  ASSETS BUILD TIME: ";echo -e $res2 $res1 's\e[0m' | awk '{print $1 - $2 $3}'
    print_box $(echo -e "$(echo $assets | sed 's/\(.*\)\\n/\1/')")
fi