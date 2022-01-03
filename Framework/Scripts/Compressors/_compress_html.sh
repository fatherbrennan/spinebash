#! /bin/bash
#
# @fatherbrennan
(echo -en "<!--\n - \n - \n - @fatherbrennan:compressor:html\n -->\n"; cat $1 | tr -d '\n' | tr -s ' ' ' ' | perl -pe 's%<!--(.*?)-->%%gs;s%[\s]?[>][\s]?[<][\s]?%><%g;s%[\s]?/>%>%g')>"$2"