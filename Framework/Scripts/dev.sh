#! /bin/bash
#
# @fatherbrennan

# Start runtime timer
t1=$(date +%s.%N)

# Imports
source 'Framework/.env'
source "$TOOLS_ANSI_ESC_CODES"

# Get relative path from arg
app="$1"

# Track asset files
assets=()

# Create cache directory if it doesn't exist
[ -d "$CACHE_DIR_TMP" ] || mkdir -p "$CACHE_DIR_TMP"

# Run build scripts
"$SCRIPTS_GET_ROUTES" || exit 1
"$SCRIPTS_MAKE_CSS" || exit 1
"$SCRIPTS_MAKE_JS" || exit 1
"$SCRIPTS_MAKE_MARKUP" || exit 1

#
# {$1} string to print [ expandable string ]
#
print_box()
{
    p(){ printf "$1"; };p_line(){ for ((i=0;i<=$b;i++));do p "$c";done }
    local a=("$@");local b=$(tput cols)-3;local c='\u2500';local d='\u2502';p "$TEXT_DIM";local l="${#a[@]}"
    p '\u250c';p_line;p '\u2510'
    for ((i=0;i<"$l";i++));do local e=$(($b-${#a[i]}));p "$d";p "%${e}s";p "${TEXT_RESET}${COLOR_GREEN}${a[i]}${TEXT_RESET}${TEXT_DIM} ${d}";done
    p '\u2514';p_line;p '\u2518'
}

# Loop through all asset files
for f in $(find "$PUBLIC_DIR" -type f)
do
    # Track assets relative path
    assets+=("${f//$app}")
done

# Print assets
if [ ! -z "$assets" ]
then
    t2=$(date +%s.%N)
    printf "\n${COLOR_GREEN}%s%fs${TEXT_RESET}\n" '  ASSETS BUILD TIME: ' "$(printf "${t1} ${t2}" | awk '{print $2 - $1}')"
    print_box "${assets[@]}"
fi