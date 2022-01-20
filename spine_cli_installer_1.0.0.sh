#!/bin/bash
#
# @fatherbrennan

#
# Set Spine CLI environment
#
set_spine()
{
    mkdir -p ~/.spine/bin/ || exit 1
    cat > ~/.spine/bin/spine <<'EOF'
#! /bin/bash
########################################################################
# Spine CLI
########################################################################
#
# @fatherbrennan
#

SPINE_VERSION=1.0.0
SPINE_ENV='Framework/.env'

# Text Properties
TEXT_RESET='\u001b[0m'
TEXT_BOLD='\u001b[1m'
TEXT_UNDERLINE='\u001b[4m'

#
# Throw exception
#
# ?{$1} specific error
# ?{$2} description line 1 (commonly command usage)
# ?{$3} description line 2
#
throw_invalid_exception() {
    local invalid='Invalid command: '
    [ -z "$1" ] || msg+=("<<${1}>>\n")
    [ -z "$2" ] || msg+=("${2}\n")
    [ -z "$3" ] || msg+=("${3}\n")
    printf '%b' "$invalid" "${msg[@]}" && exit 1
}

#
# Print command usage
#
usage() {
    printf 'Usage: spine <command> <extension>'
}

#
# Print command help
#
show_help() {
    printf "${TEXT_BOLD}spine${TEXT_RESET}\n $(usage)\n\n${TEXT_UNDERLINE}commands${TEXT_RESET}\n\n ${TEXT_BOLD}dev, start${TEXT_RESET}\n\tbuild app assets in dev mode\n\n ${TEXT_BOLD}clear${TEXT_RESET}\n\tclear the framework cache including assets\n\n ${TEXT_BOLD}open${TEXT_RESET}\n\topen the app in the default web browser\n\n ${TEXT_BOLD}-h, --help${TEXT_RESET}\n\tdisplay command info\n\n ${TEXT_BOLD}-v, --version${TEXT_RESET}\n\tdisplay version info\n\n${TEXT_UNDERLINE}extensions${TEXT_RESET}\n\n ${TEXT_BOLD}-s, --script${TEXT_RESET}\n\textends [ start ] [ dev ]\n\t  run config SCRIPT_TAIL after spine build process\n\n${TEXT_UNDERLINE}examples${TEXT_RESET}\n\n ${TEXT_BOLD}spine dev --script${TEXT_RESET}\n\trun dev build process and then run config defined script\n\twhere SCRIPT_TAIL=\"npm dev\". Can be used within framework\n\tenvironments such as the Electron framework\n\n ${TEXT_BOLD}spine open${TEXT_RESET}\n\topen the Public/index.html file using the machine's\n\tdefault web browser"
}

#
# Print help redirect
#
show_help_redirect() {
    printf '%s' "Use 'spine --help' for command information"
}

#
# Print version
#
show_version() {
    printf '%s' "$SPINE_VERSION"
}

# Exit if no args
[ -z "$1" ] && throw_invalid_exception 'Empty Argument' " $(usage)"

#
# Handle command arguments
#
case "$1" in
-h | --help)
    show_help && exit 0
    ;;
-v | --version)
    show_version && exit 0
    ;;
esac

# Imports
[ -f "$SPINE_ENV" ] && source "$SPINE_ENV" || throw_invalid_exception 'Missing Spinebash Environment'
source "$CONFIG"

# Get relative path
app="$(pwd)/"

#
# Handle command arguments (environment exclusive)
#
case "$1" in
dev | start)
    shift
    EXTENSION=''
    if [ -n "$1" ]
    then
        case "$1" in
        -s | --script) EXTENSION="$SCRIPT_TAIL" ;;
        *) throw_invalid_exception "'${1}' is not a valid extension" " $(usage)" "$(show_help_redirect)" ;;
        esac
    fi
    "$SPINE_DEV" "$app" && [ -n "$EXTENSION" ] && "$EXTENSION"
    ;;
clear)
    "$SPINE_CLEAR" && exit 0
    ;;
open)
    # OS check
    a=$(uname -s)
    b=$(pwd)
    case "$a" in

    Linux*)
        cmd='xdg-open'
        ;;
    Darwin*)
        cmd='open'
        ;;
    CYGWIN*)
        cmd='cmd.exe /C start'
        ;;
    MINGW*)
        cmd='start'
        b=$(pwd -W)
        ;;
    *)
        printf '%s' "UNKNOWN MACHINE: ${a}"
        ;;
    esac
    # Open homepage in default browser
    "$cmd" "file://${b}/Public/index.html" && exit 0
    ;;
*)
    throw_invalid_exception 'Invalid Argument' " $(usage)" "$(show_help_redirect)"
    ;;
esac
EOF
    chmod 777 ~/.spine/bin/spine
}

#
# Add spine path variable and source environments
#
add()
{
    local a='PATH=~/.spine/bin:$PATH'
    if [ -f ~/"$1" ]
    then
        if [ "$(grep $a ~/$1 | wc -c)" -eq 0 ]
        then
            printf '%s\n' "$a" >>~/"$1"
        fi
    else
        printf '%s\n' "$a" >~/"$1"
    fi
    source ~/"$1"
}

# Add to .bashrc file
set_spine && add '.bashrc' || exit 1

# Add to .zshrc file shell exists on machine
type zsh &>/dev/null && add '.zshrc' || exit 1
printf '%s' 'Spine CLI install successful'
exit 0