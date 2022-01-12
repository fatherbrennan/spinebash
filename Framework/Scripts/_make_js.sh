#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'
source "$CONFIG"
source "$TOOLS_GET_TMP"
source "$TOOLS_IS_TRUE"
source "$TOOLS_PRINT_L"
source "$TOOLS_SET_FILE_PATH"

# Limit temp files to the framework cache
tmp1=$(get_tmp)

# Clear directory
rm -rf "$PUBLIC_DIR_JS"*

# Prepare script cache file
set_file_path "$CACHE_SCRIPTS"

# Check config file if scripts should use defer attribute
is_true "$JS_DEFER" && defer=' defer' || defer=''

# Track if router needs to be added
add_router=true

#
# {$1} file path
#
add_html_script_tag()
{
    (print_l "<script src=\"js/$(basename $1)\"${defer}></script>")>>"$CACHE_SCRIPTS"
}

# Add asset files from resources
if is_true "$COMPRESS_JS"
then
    # Use framework compressor if falsy value
    if [ -z "$USE_COMPRESSOR_JS" ]
    then
        compressor="$COMPRESSORS_JS"
        for f in $(find "$RESOURCES_DIR_JS" -type f -name '*.js')
        do
            # Asset path
            script="${PUBLIC_DIR_JS}${f##*/}"
            # Track populated files
            [ -s "$f" ] && print_l "$f"
            # Add router to first asset
            is_true "$add_router" && router_contents=$(cat "$CONTROLLERS_LOCAL_JS") && add_router=false || router_contents=''
            # Check config file and compress asset file if true, then add assets
            (echo -e "$router_contents";cat "$f")>"$tmp1"
            $compressor "$tmp1" "$script"
            # Add script tag to temp file
            add_html_script_tag "$script"
        done
    else
        # Asset file name
        input_files=''
        for f in $(find "$RESOURCES_DIR_JS" -type f -name '*.js')
        do
            # Track populated files
            [ -s "$f" ] && print_l "$f"
            # Add router
            input_files+="${f} "
        done
        # Add script tag to temp file
        add_html_script_tag "$OUTPUT_COMPRESSED_JS"
        compressor=${USE_COMPRESSOR_JS//INPUT/$input_files}
        compressor=${compressor//OUTPUT/$PUBLIC_DIR_JS$OUTPUT_COMPRESSED_JS}
        # Unsafe execute
        eval $compressor
    fi
    print_l "COMPRESSOR (JavaScript): ${compressor}"
else
    for f in $(find "$RESOURCES_DIR_JS" -type f -name '*.js')
    do
        # Asset path
        script="${PUBLIC_DIR_JS}${f##*/}"
        # Track populated files
        [ -s "$f" ] && print_l "$f"
        # Add router to first asset
        is_true "$add_router" && router_contents=$(cat "$CONTROLLERS_LOCAL_JS") && add_router=false || router_contents=''
        # Check config file and compress asset file if true, then add assets
        (echo -e "$router_contents";cat "$f")>"$tmp1"
        (cat "$tmp1")>"$script"
        # Add script tag to temp file
        add_html_script_tag "$script"
    done
fi

# Remove created temp files
rm -rf "$tmp1"