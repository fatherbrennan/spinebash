#! /bin/bash
#
# @fatherbrennan

# Start runtime timer
t1=$(date +%s.%N)

source 'Framework/.env'
source "$TOOLS_ANSI_ESC_CODES"

# Get relative path from arg
app="$1"

# Track asset files
assets=""

# Create cache directory if it doesn't exist
[ -d "${app}Framework/Scripts/cache/tmp" ] || mkdir -p "${app}Framework/Scripts/cache/tmp"

# Run build scripts
"${app}Framework/Scripts/_get_routes.sh" || exit 1
"${app}Framework/Scripts/_make_css.sh" || exit 1
"${app}Framework/Scripts/_make_js.sh" || exit 1
"${app}Framework/Scripts/_make_markup.sh" || exit 1

# Print
print_box()
{
    local a=("$@");local b=$(tput cols)-3;local c='\u2500';local d='\u2502';printf "$TEXT_DIM"
    p(){ printf "$1"; };p_line(){ for ((i=0;i<=$b;i++));do p "$c";done }
    p '\u250c';p_line;p '\u2510'
    for i in "${a[@]}";do local e=$(($b-${#i}));p "$d";printf "%${e}s";p "${TEXT_RESET}${COLOR_GREEN}${i}${TEXT_RESET}${TEXT_DIM} ${d}";done
    p '\u2514';p_line;p '\u2518'
}

# Loop through all asset files
for f in $(find "${app}Public/" -type f)
do
    # Track assets relative path
    assets+="${f//$app} "
done

# Print assets
if [ ! -z "$assets" ]
then
    t2=$(date +%s.%N)
    printf "\n${COLOR_GREEN}%s%fs${TEXT_RESET}\n" '  ASSETS BUILD TIME: ' "$(printf "${t1} ${t2}" | awk '{print $2 - $1}')"
    print_box $(printf "$assets")
fi