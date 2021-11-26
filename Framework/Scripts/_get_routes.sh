#! /bin/bash
# 
# @fatherbrennan

# Get relative path

# Resources
routes='Resources/routes.sh'

throw_exception()
{
    echo -e "line ${1}: Error: Invalid route declaration${3}\n \e[31m${2}\e[39m\nUsage: ROUTE 'new/url/path' VIEW 'path/to/file'" && exit 1
}

read_routes()
{
    # Turn input into array of strings
    IFS=' ' read -r -a args <<< "$2"

    # Throw exception for too many arguments declared
    [ "${#args[@]}" -gt "4" ] && throw_exception "$1" "$2" ': <<Too many arguments>>'

    # Prossess only lines of correct arguments
    if [ "${#args[@]}" -eq "4" ]
    then
        # Throw invalid declaration
        [ "ROUTE" = "${args[0]}" ] && [ "VIEW" = "${args[2]}" ] || throw_exception "$1" "$2"
        # VIEW is valid file path
        f=$(echo "${args[3]}" | sed "s/'//g")
        [ -f "Resources/views/content/${f}.html" ] || throw_exception "$1" "$2" ': <<Missing file>>'
        # Is a valid url route
        [[ "$f" =~ ^[A-Za-z][-A-Za-z0-9_:./]*$ ]] || throw_exception "$1" "$2" ': <<Invalid URL>>'
    fi
}

# Views are unique
duplicates=$(echo $(cat "$routes") | grep -Po "(?<=(VIEW ')).*(?=')" | uniq -d)
[ -n "$duplicates" ] && echo -e "Routes: Error: Invalid route declaration: <<Duplicate view path>>\n\e[31m${duplicates}\e[39m\n->VIEW 'path/to/file' must be unique" && exit 1

# Read the routes file by line
line=0
while IFS= read -r l || [[ -n "$l" ]]
do
    ((line++))
    # Dont read comments (hash lines)
    [[ "$l" == \#* ]] || read_routes "$line" "$l"
done < "$routes"