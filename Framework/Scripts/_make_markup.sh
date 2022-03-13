#! /bin/bash
#
# @fatherbrennan

# Imports
source 'Framework/.env'
source "$CONFIG"
source "$TOOLS_DO_INCLUDE"
source "$TOOLS_GET_TMP"
source "$TOOLS_INSERT_FILE_CONTENTS"
source "$TOOLS_IS_TRUE"
source "$TOOLS_PRINT_L"

# Limit temp files to the framework cache
tmp1=$(get_tmp)
tmp2=$(get_tmp)

# Use clean layout
(cat "$LAYOUT")>"$tmp1"

#
# Remove placeholder pattern from file
#
# {$1} placeholder [ RegEx pattern ]
# {$2} file [ template file containing the placeholder ]
#
remove_placeholder_in_asset()
{
    local a=$(sed "/$1/d" "$tmp1")
    printf '%s' "$a">"$tmp1"
}

#
# {$1} placeholder (wrapper file) [ RegEx pattern ]
# {$2} wrapper file [ template file containing the placeholder ]
# {$3} placeholder (layout file) [ RegEx pattern ]
# {$4} content file [ file to be wrapped ]
#
wrap_and_insert_in_asset()
{
    (cat "$2")>"$tmp2"
    insert_file_contents "$1" "$tmp2" "$4"
    insert_file_contents "$3" "$tmp1" "$tmp2"
}

# Get declared routes from cache
IFS=' ' read -ra routes_array <<< "$(cat $CACHE_ROUTES)"
routes_array_len="${#routes_array[@]}"

# Loop through all content views
for f in $(find "$RESOURCES_DIR_VIEWS_CONTENT" -type f -name '*.html')
do
    # Only add populated views
    if do_include "$f"
    then
        # Get view route (held in next index from view)
        r="${f%.*}"
        r="${r#$RESOURCES_DIR_VIEWS_CONTENT*}"
        for ((i=0;i<${routes_array_len};i++));
        do
            if [ "${routes_array[$i]}" = "$r" ]
            then
                view_route="${routes_array[$i+1]}"
                break
            fi
        done
        # Add view route to view wrapper
        (sed "s,${PLACEHOLDER_ROUTER},${view_route}," "$WRAPPERS_VIEW")>>"$tmp2"
        # Wrap content with view wrapper
        insert_file_contents "$PLACEHOLDER_CONTENT" "$tmp2" "$f" && print_l "$f"
    fi
done

# Insert views into asset
insert_file_contents "$PLACEHOLDER_VIEWS" "$tmp1" "$tmp2"

# Perform checks and include static views if true
is_true "$USE_NAV" && do_include "$RESOURCES_NAV" && wrap_and_insert_in_asset "$PLACEHOLDER_CONTENT" "$WRAPPERS_NAV" "$PLACEHOLDER_NAV" "$RESOURCES_NAV" && print_l "$RESOURCES_NAV" || remove_placeholder_in_asset "$PLACEHOLDER_NAV"
is_true "$USE_FRAME" && do_include "$RESOURCES_FRAME" && wrap_and_insert_in_asset "$PLACEHOLDER_CONTENT" "$WRAPPERS_FRAME" "$PLACEHOLDER_FRAME" "$RESOURCES_FRAME" && print_l "$RESOURCES_FRAME" || remove_placeholder_in_asset "$PLACEHOLDER_FRAME"
do_include "$RESOURCES_HEAD" && insert_file_contents "$PLACEHOLDER_HEAD" "$tmp1" "$RESOURCES_HEAD" && print_l "$RESOURCES_HEAD" || remove_placeholder_in_asset "$PLACEHOLDER_HEAD"
insert_file_contents "$PLACEHOLDER_SCRIPT" "$tmp1" "$CACHE_SCRIPTS"
insert_file_contents "$PLACEHOLDER_STYLES" "$tmp1" "$CACHE_STYLES"

# Add asset
if is_true "$COMPRESS_HTML"
then
    # Use framework compressor if falsy value
    if [ -z "$USE_COMPRESSOR_HTML" ]
    then
        compressor="$COMPRESSORS_HTML"
        $compressor "$tmp1" "$PUBLIC_INDEX"
    else
        compressor=${USE_COMPRESSOR_HTML//INPUT/$tmp1}
        compressor=${compressor//OUTPUT/$PUBLIC_INDEX}
        # Unsafe execute
        eval $compressor
    fi
    print_l "COMPRESSOR (HTML): ${compressor}"
else
    (cat "$tmp1")>"$PUBLIC_INDEX"
fi

# Remove created temp files
rm -rf "$tmp1" "$tmp2" "$CACHE_SCRIPTS" "$CACHE_ROUTES"