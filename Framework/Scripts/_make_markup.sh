#! /bin/bash
# 
# @fatherbrennan

# Imports
source '.config'
source 'Framework/Scripts/Tools/is_true.sh'
source 'Framework/Scripts/Tools/do_include.sh'

# Asset file
a='Public/index.html'

# Resources
b='Resources/views/static/Nav/nav.html'
c='Resources/views/static/Frame/frame.html'
d='Resources/views/content/'
e='Resources/views/static/Head/head.html'
routes='Resources/routes.sh'

# Compressor
compressor='Framework/Scripts/Compressors/_compress_html.sh'

# Wrappers
bw='Framework/Wrappers/Nav/'
cw='Framework/Wrappers/Frame/'
dw='Framework/Wrappers/View/'
layout='Framework/Wrappers/layout'

# Limit temp files to the framework cache
tmp1="Framework/Scripts/cache/tmp/.tmp${RANDOM}"
tmp2="Framework/Scripts/cache/tmp/.tmp${RANDOM}"
script=$(cat "Framework/Scripts/cache/tmp/scripts")

# Use clean layout
echo "$(cat $layout)">"$tmp1"

# Track used resource files
resources=""

# Wrap content with defined wrapper file
wrap_content()
{
    cat "${1}wrap" | sed -e "/{{ content }}/{r $2" -e "d}"
}

# Loop through all content views
for f in $(find "$d" -type f -name '*.html')
do
    # Only add populated views
    if [ -s "$f" ]
    then
        # Track
        resources+="${f}\n"
        # Get view route
        r=$(echo "${f%.*}" | sed -e 's#Resources/views/content/##')
        route=$(grep -ws "'${r}'" "$routes" | sed "s#^[^']*'\([^']*\)'.*#\1#")
        # Wrap content view
        views+=$(cat "${dw}wrap" | sed -e "/{{ view }}/{r $f" -e "d}" | sed -e "s@{{ route }}@/${route}@")
    fi
done

# If checks return true, then include in markup
is_true "$USE_NAV" && do_include "$b" && nav=$(wrap_content "$bw" "$b") || nav=""
is_true "$USE_FRAME" && do_include "$c" && frame=$(wrap_content "$cw" "$c") || frame=""
do_include "$e" && head=$(cat "$e") || head=""

# Buld the asset file
# 
# Head
awk -v x='{{ head }}' -v y="$head" '{sub(x, y)}1' "$tmp1" > "$tmp2" && mv "$tmp2" "$tmp1"

# Frame
awk -v x='{{ frame }}' -v y="$frame" '{sub(x, y)}1' "$tmp1" > "$tmp2" && mv "$tmp2" "$tmp1"

# Nav
awk -v x='{{ nav }}' -v y="$nav" '{sub(x, y)}1' "$tmp1" > "$tmp2" && mv "$tmp2" "$tmp1"

# Views
awk -v x='{{ views }}' -v y="$views" '{sub(x, y)}1' "$tmp1" > "$tmp2" && mv "$tmp2" "$tmp1"

# Scripts
awk -v x='{{ script }}' -v y="$script" '{sub(x, y)}1' "$tmp1" > "$tmp2" && mv "$tmp2" "$tmp1"

# Check config file and compress asset file if true
is_true "$COMPRESS_HTML" && $compressor "$tmp1" "$a" || echo "$(cat $tmp1)">"$a"

# Remove created temp files
rm -rf "$tmp1" "$tmp2" "$script"

# Track populated files
[ -z "$head" ] || resources+="${e}\n"
[ -z "$frame" ] || resources+="${b}\n"
[ -z "$nav" ] || resources+="${b}\n"

# Print used resources
[ -z "$resources" ] || echo -e "$(echo $resources | sed 's/\(.*\)\\n/\1/')"