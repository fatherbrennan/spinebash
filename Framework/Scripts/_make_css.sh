#! /bin/bash
#
# @fatherbrennan

# Imports
source '.config'
source 'Framework/Scripts/Tools/is_true.sh'

# Asset file
a='Public/css/app.css'

# Resources
b='Resources/css/'

# Controller
router_css='Framework/Controllers/localRouterController.css'

# Limit temp files to the framework cache
tmp1="Framework/Scripts/cache/tmp/.tmp${RANDOM}"

# Add bootstrap css
bs_css='Framework/Wrappers/css.css'

# Add framework css
(cat "$bs_css";cat "$router_css")>>"$tmp1"

# Clear asset
truncate -s 0 "$a"

# Track used resource files
resources=''

# Create CSS file using resources
for f in $(find "$b" -type f -name '*.css')
do
    # Track populated files
    [ -s "$f" ] && resources+="${f}\n"
    # Concatenate resources
    cat "$f">>"$tmp1"
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
        compressor=$(echo "$USE_COMPRESSOR_CSS" | sed "s%INPUT%$tmp1%" | sed "s%OUTPUT%$a%")
        eval $compressor
    fi
    echo "COMPRESSOR (CSS): ${compressor}"
else
    echo "$(cat $tmp1)">"$a"
fi

# Remove created temp files
rm -rf "$tmp1"

# Print used resources
[ -z "$resources" ] || echo -e "$(echo $resources | sed 's/\(.*\)\\n/\1/')"