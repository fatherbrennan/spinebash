#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'
source "$TOOLS_ANSI_ESC_CODES"
source "$TOOLS_SET_FILE_PATH"

# Track all valid routes
router_args=''

#
# ?{$1} invalid route declaration error message. preferred format ': <<error_message>>'
# ?{$2} line number
# ?{$3} error
#
throw_exception()
{
    local declaration="Declare Route: ROUTE 'url/path' VIEW 'path/to/file'"
    local msg=()
    [ -z "$1" ] || msg+=("Error: Invalid route declaration${1}\n")
    [ -z "$2" ] || msg+=(" (line ${2}): ")
    [ -z "$3" ] || msg+=(" ${COLOR_RED}${3}${TEXT_RESET}\n")
    printf "%b" "${msg[@]}" "$declaration" && exit 1
}

#
# {$1} line number
# {$2} line contents
#
read_routes()
{
    # Turn input into array of strings
    IFS=' '
    read -ra args <<< "$2"
    
    # Throw exception for too many arguments declared
    [ "${#args[@]}" -gt "4" ] && throw_exception ': <<Too many arguments or unexpected space>>' "$1" "$2"
    
    # Prossess only lines of correct arguments
    if [ "${#args[@]}" -eq "4" ]
    then
        # Throw invalid declaration
        [ "ROUTE" = "${args[0]}" ] && [ "VIEW" = "${args[2]}" ] || throw_exception ': <<Invalid Syntax>>' "$1" "$2"
        # Check if VIEW is a valid file path
        f="${args[3]//\'/}"
        [ -f "${RESOURCES_DIR_VIEWS_CONTENT}${f}.html" ] || throw_exception ': <<Missing file>>' "$1" "$2"
        router_args+="${f}\n"
        # Check if ROUTE is a valid url path
        r="${args[1]//\'/}"
        [[ "$r" =~ [^-[:alnum:]\/\.\_\~\#\+\?\*\&\%\!\=] ]] && throw_exception ': <<Invalid URL>>' "$1" "$2"
        # Escape '&' - sed interpretes char
        router_args+="/${r//&/\\&}\n"
    fi
}

# Read the routes file by line
line=0
while IFS= read -r l || [[ -n "$l" ]]
do
    ((line++))
    # Dont read comments (hash lines)
    [[ "$l" =~ ^[[:space:]]*?\# ]] || read_routes "$line" "$l"
done < "$RESOURCES_ROUTES"

# Check if routes and views are unique
duplicates=$(printf "%b" "$router_args" | sort | uniq -d | tr -s '\n' ' ')

if [ -n "$duplicates" ]
then
    throw_exception ': <<Duplicate>>' '' "$duplicates"
else
    set_file_path "$CACHE_ROUTES" && printf "%b" "${router_args//\\n/ }">"$CACHE_ROUTES"
fi