#! /bin/bash
# 
# @fatherbrennan
app=$1
find "${app}Public" -type f -delete
find "${app}Framework/Scripts/cache/" -type f -delete