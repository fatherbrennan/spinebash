#! /bin/bash
#
# @fatherbrennan

# Imports
source '.config'
source 'Framework/Scripts/Tools/is_true.sh'
source 'Framework/Scripts/Tools/set_file_path.sh'

# Asset file
a='Public/css/app.css'

# Resources directory
b='Resources/css/'

# Controller
css_router='Framework/Controllers/localRouterController.css'

# Limit temp files to the framework cache
tmp1="Framework/Scripts/cache/tmp/.tmp${RANDOM}"

# Add bootstrap css
css_bs='Framework/css.css'

# Add framework css
(cat "$css_bs";cat "$css_router")>>"$tmp1"

# Prepare asset
set_file_path "$a"

# Create single CSS file using resources
for f in $(find "$b" -type f -name '*.css')
do
    # Track populated files
    [ -s "$f" ] && echo "$f"
    # Concatenate resources
    (cat "$f")>>"$tmp1"
done

# Add asset
if is_true "$COMPRESS_CSS"
then
    # Use framework compressor if falsy value
    if [ -z "$USE_COMPRESSOR_CSS" ]
    then
        compressor='Framework/Scripts/Compressors/_compress_css.sh'
        $compressor "$tmp1" "$a"
    else
        compressor=${USE_COMPRESSOR_CSS//INPUT/$tmp1}
        compressor=${compressor//OUTPUT/$a}
        # Unsafe execute
        eval $compressor
    fi
    echo "COMPRESSOR (CSS): ${compressor}"
else
    (cat $tmp1)>"$a"
fi

# Remove created temp files
rm -rf "$tmp1"