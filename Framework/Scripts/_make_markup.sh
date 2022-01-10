#! /bin/bash
#
# @fatherbrennan

# Imports
source '.config'
source 'Framework/Scripts/Tools/is_true.sh'
source 'Framework/Scripts/Tools/do_include.sh'
source 'Framework/Scripts/Tools/insert_file_contents.sh'

# Asset file
a='Public/index.html'

# Resources
VIEW_NAV='Resources/views/static/Nav/nav.html'
VIEW_FRAME='Resources/views/static/Frame/frame.html'
VIEW_HEAD='Resources/views/static/Head/head.html'
d='Resources/views/content/'
TMP_ROUTES='Framework/Scripts/cache/routes'

# Wrappers
WRAPPER_FRAME='Framework/Wrappers/Frame/wrap'
WRAPPER_NAV='Framework/Wrappers/Nav/wrap'
WRAPPER_VIEW='Framework/Wrappers/View/wrap'
LAYOUT='Framework/layout'

# Limit temp files to the framework cache
tmp1="Framework/Scripts/cache/tmp/.tmp${RANDOM}"
tmp2="Framework/Scripts/cache/tmp/.tmp${RANDOM}"
script="Framework/Scripts/cache/tmp/scripts"

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
    local a=$(sed "s/$1//" "$tmp1")
    echo "$a">"$tmp1"
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
IFS=' ' read -ra routes_array <<< "$(cat $TMP_ROUTES)"
routes_array_len="${#routes_array[@]}"

# Loop through all content views
for f in $(find "$d" -type f -name '*.html')
do
    # Only add populated views
    if do_include "$f"
    then
        # Get view route (held in next index from view)
        r="${f%.*}"
        r="${r#$d*}"
        for ((i=0;i<${routes_array_len};i++));
        do
            if [ "${routes_array[$i]}" = "$r" ]
            then
                view_route="${routes_array[$i+1]}"
                break
            fi
        done
        # Add view route to view wrapper
        (cat "$WRAPPER_VIEW" | sed "s,{{\s*route\s*}},$view_route,")>>"$tmp2"
        # Wrap content with view wrapper
        insert_file_contents '{{\s*content\s*}}' "$tmp2" "$f" && echo "$f"
    fi
done

# Insert views into asset
insert_file_contents '{{\s*views\s*}}' "$tmp1" "$tmp2"

# Perform checks and include static views if true
is_true "$USE_NAV" && do_include "$VIEW_NAV" && wrap_and_insert_in_asset '{{\s*content\s*}}' "$WRAPPER_NAV" '{{\s*nav\s*}}' "$VIEW_NAV" && echo "$VIEW_NAV" || remove_placeholder_in_asset '{{\s*nav\s*}}'
is_true "$USE_FRAME" && do_include "$VIEW_FRAME" && wrap_and_insert_in_asset '{{\s*content\s*}}' "$WRAPPER_FRAME" '{{\s*frame\s*}}' "$VIEW_FRAME" && echo "$VIEW_FRAME" || remove_placeholder_in_asset '{{\s*frame\s*}}'
do_include "$VIEW_HEAD" && insert_file_contents '{{\s*head\s*}}' "$tmp1" "$VIEW_HEAD" && echo "$VIEW_HEAD" || remove_placeholder_in_asset '{{\s*head\s*}}'
insert_file_contents '{{\s*script\s*}}' "$tmp1" "$script"

# Add asset
if is_true "$COMPRESS_HTML"
then
    # Use framework compressor if falsy value
    if [ -z "$USE_COMPRESSOR_HTML" ]
    then
        compressor='Framework/Scripts/Compressors/_compress_html.sh'
        $compressor "$tmp1" "$a"
    else
        compressor=${USE_COMPRESSOR_HTML//INPUT/$tmp1}
        compressor=${compressor//OUTPUT/$a}
        # Unsafe execute
        eval $compressor
    fi
    echo "COMPRESSOR (HTML): ${compressor}"
else
    (cat "$tmp1")>"$a"
fi

# Remove created temp files
rm -rf "$tmp1" "$tmp2" "$script"