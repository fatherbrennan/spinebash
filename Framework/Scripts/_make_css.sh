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

# Asset file
asset_css=''

# Limit temp files to the framework cache
tmp1=$(get_tmp)

# Add framework css
(cat "$BOOTSTRAP_CSS";cat "$CONTROLLERS_LOCAL_CSS")>>"$tmp1"

# Create single CSS file using resources
for f in $(find "$RESOURCES_DIR_CSS" -type f -name '*.css')
do
    # Track populated files
    [ -s "$f" ] && print_l "$f"
    # Concatenate resources
    (cat "$f")>>"$tmp1"
done

# Add asset
if is_true "$COMPRESS_CSS"
then
    # Use compressed file path
    asset_css="${PUBLIC_DIR_CSS}${OUTPUT_COMPRESSED_CSS}"
    # Prepare asset
    set_file_path "$asset_css"
    # Use framework compressor if falsy value
    if [ -z "$USE_COMPRESSOR_CSS" ]
    then
        compressor="$COMPRESSORS_CSS"
        $compressor "$tmp1" "$asset_css"
    else
        compressor=${USE_COMPRESSOR_CSS//INPUT/$tmp1}
        compressor=${compressor//OUTPUT/$asset_css}
        # Unsafe execute
        eval $compressor
    fi
    echo "COMPRESSOR (CSS): ${compressor}"
else
    # Use uncompressed file path
    asset_css="${PUBLIC_DIR_CSS}${OUTPUT_UNCOMPRESSED_CSS}"
    # Prepare asset
    set_file_path "$asset_css"
    (cat "$tmp1")>"$asset_css"
fi

# Remove created temp files
rm -rf "$tmp1"