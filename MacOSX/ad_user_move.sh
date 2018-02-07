#!/usr/bin/env bash
# Bash skips errors and resumes by default
# 
# script is to copy user's files copied with "companion" script from temp storage to user's folders

# set folder that is storing user files 
vTempSource=/Users/Shared/<username>/

rsync -amrtv --delete-before --progress "$vTempSource"Documents ~/
rsync -amrtv --delete-before --progress "$vTempSource"Movies ~/
rsync -amrtv --delete-before --progress "$vTempSource"Music ~/
rsync -amrtv --delete-before --progress "$vTempSource"Pictures ~/
rsync -amrtv --delete-before --progress "$vTempSource"Downloads ~/
rsync -amrtv --delete-before --progress "$vTempSource"Desktop ~/
rsync -amrtv --delete-before --progress "$vTempSource"Public ~/
