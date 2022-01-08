#! /bin/bash
# 
# @fatherbrennan

# Resources
ROUTES='Resources/routes.sh'

# Imports
source 'Framework/Scripts/Tools/ansi_esc_codes.sh'

# Track all router arguments 
router_args=''

#
# {$1} invalid route declaration error message. preferred format ': <<error_message>>'
# {$2} line number
# ?{$3} error
#
throw_exception()
{
    [ -z "$1" ] && local error_message='' || local error_message="Error: Invalid route declaration${1}\n"
    [ -z "$2" ] && local line='' || local line="line ${2}: " 
    [ -z "$3" ] && local error='' || local error="${COLOR_RED}${3}${TEXT_RESET}\n"
    local declaration="Declare Route: ROUTE 'url/path' VIEW 'path/to/file'"
    echo -e "${line}${error_message} ${error}${declaration}" && exit 1
}

#
# {$1} line number
# {$2} line contents
#
read_routes()
{
    # Turn input into array of strings
    IFS=' ' read -r -a args <<< "$2"

    # Throw exception for too many arguments declared
    [ "${#args[@]}" -gt "4" ] && throw_exception ': <<Too many arguments or unexpected space>>' "$1" "$2"

    # Prossess only lines of correct arguments
    if [ "${#args[@]}" -eq "4" ]
    then
        # Throw invalid declaration
        [ "ROUTE" = "${args[0]}" ] && [ "VIEW" = "${args[2]}" ] || throw_exception ': <<Invalid Syntax>>' "$1" "$2"
        # Check if VIEW is a valid file path
        f=$(echo "${args[3]}" | sed "s/'//g")
        [ -f "Resources/views/content/${f}.html" ] || throw_exception ': <<Missing file>>' "$1" "$2"
        router_args+="$f\n"
        # Check if ROUTE is a valid url path
        r=$(echo "${args[1]}" | sed "s/'//g")
        [[ "$r" =~ [^-[:alnum:]\/\.\_\~\#\+\?\*\&\%\!\=] ]] && throw_exception ': <<Invalid URL>>' "$1" "$2" && true
        router_args+="$r\n"
    fi
}

# Read the routes file by line
line=0
while IFS= read -r l || [[ -n "$l" ]]
do
    ((line++))
    # Dont read comments (hash lines)
    [[ "$l" =~ ^[[:space:]]*?\# ]] || read_routes "$line" "$l"
done < "$ROUTES"

# Check if routes and views are unique
duplicates=$(echo -e "$router_args" | sort | uniq -d)
[ -n "$duplicates" ] && throw_exception ': <<Duplicate>>' '' "$duplicates" || echo -n