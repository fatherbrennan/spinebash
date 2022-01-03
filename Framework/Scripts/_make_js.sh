#! /bin/bash
#
# @fatherbrennan

# Imports
source '.config'
source 'Framework/Scripts/Tools/is_true.sh'

# Asset directory
a='Public/js/'

# Resources
b='Resources/js/'

# Controller
router='Framework/Controllers/localRouterController.js'

# Limit temp files to the framework cache
tmp1="Framework/Scripts/cache/tmp/.tmp${RANDOM}"
scripts='Framework/Scripts/cache/tmp/scripts'

# Clear directory
rm -rf "$a"*

# Clear temp script
>"$scripts"

# Track used resource files
resources=""

# Check config file if scripts should use defer attribute
is_true "$JS_DEFER" && defer=' defer' || defer=''

# Track router addition
add_router=true

# Add html script tag to cache
add_html_script_tag()
{
    echo "<script src=\"js/$(basename $1)\"${defer}></script>">>"$scripts"
}

# Add asset files from resources
if is_true "$COMPRESS_JS"
then
    # Use framework compressor if falsy value
    if [ -z "$USE_COMPRESSOR_JS" ]
    then
        compressor='Framework/Scripts/Compressors/_compress_js.sh'
        for f in $(find "$b" -type f -name '*.js')
        do
            # Asset path
            script="${a}${f##*/}"
            # Track populated files
            [ -s "$f" ] && resources+="${f}\n"
            # Add router to first asset
            is_true "$add_router" && router_contents=$(cat "$router") && add_router=false || router_contents=''
            # Check config file and compress asset file if true, then add assets
            (echo -e "$router_contents"; cat "$f")>"$tmp1"
            $compressor "$tmp1" "$script"
            # Add script tag to temp file
            add_html_script_tag "$script"
        done
    else
        mini_js="app.min.js"
        input_files=''
        for f in $(find "$b" -type f -name '*.js')
        do
            # Track populated files
            [ -s "$f" ] && resources+="${f}\n"
            # Add router
            input_files+="${f} "
        done
        # Add script tag to temp file
        add_html_script_tag "$mini_js"
        compressor=$(echo "$USE_COMPRESSOR_JS" | sed "s%INPUT%$input_files%" | sed "s%OUTPUT%${a}${mini_js}%")
        eval $compressor
    fi
    echo "COMPRESSOR (JavaScript): ${compressor}"
else
    for f in $(find "$b" -type f -name '*.js')
    do
        # Asset path
        script="${a}${f##*/}"
        # Track populated files
        [ -s "$f" ] && resources+="${f}\n"
        # Add router to first asset
        is_true "$add_router" && router_contents=$(cat "$router") && add_router=false || router_contents=''
        # Check config file and compress asset file if true, then add assets
        (echo -e "$router_contents"; cat "$f")>"$tmp1"
        cat "$tmp1">"$script"
        # Add script tag to temp file
        add_html_script_tag "$script"
    done
fi

# Remove created temp files
rm -rf "$tmp1"

# Print used resources
[ -z "$resources" ] || echo -e "$(echo $resources | sed 's/\(.*\)\\n/\1/')"