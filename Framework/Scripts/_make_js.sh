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

# Compressor
compressor='Framework/Scripts/Compressors/_compress_js.sh'

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

# Add asset files from resources
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
    is_true "$COMPRESS_JS" && $compressor "$tmp1" "$script" || cat "$tmp1">"$script"
    # Add script tag to temp file
    echo "<script src=\"js/$(basename $script)\"${defer}></script>">>"$scripts"
done

# Remove created temp files
rm -rf "$tmp1"

# Print used resources
[ -z "$resources" ] || echo -e "$(echo $resources | sed 's/\(.*\)\\n/\1/')"