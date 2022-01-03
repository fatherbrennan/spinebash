#! /bin/bash
#
# @fatherbrennan
(echo -en "/**\n * \n * \n * @fatherbrennan:compressor:css\n */\n"; cat $1 | tr -d '\n' | perl -pe 's`/\*(.*?)\*/``gs' | tr -s ' ' ' ' | perl -pe 's`[\s]?[{][\s]?`{`g;s`[\s]?[}][\s]?`}`g;s`[\s]?[:][\s]?`:`g;s`[\s]?[;][\s]?`;`g;s`[\s]?[,][\s]?`,`g;s`[\s]?[/][\s]?`/`g;s`[\s]?[(][\s]?`(`g;s`[\s]?[)][\s]?`)`g')>"$2"