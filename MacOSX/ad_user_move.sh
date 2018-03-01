#!/usr/bin/env bash
# Bash skips errors and resumes by default
# 
# script is to copy user's files copied with "companion" script from temp storage to user's folders
# shortened URL = https://goo.gl/KZpX2a

# set username variable
vUserName="<username>"

# set folder that is storing user files 
vTempSource=/Users/Shared/"$vUserName"/

# Move files
mv "$vTempSource"Documents/* /Users/"$vUserName"/Documents
mv "$vTempSource"Movies/* /Users/"$vUserName"/Movies
mv "$vTempSource"Music/* /Users/"$vUserName"/Music
mv "$vTempSource"Pictures/* /Users/"$vUserName"/Pictures
mv "$vTempSource"Downloads/* /Users/"$vUserName"/Downloads
mv "$vTempSource"Desktop/* /Users/"$vUserName"/Desktop
mv "$vTempSource"Public/* /Users/"$vUserName"/Public

# Change owner from sscpslocal to user
chown -Rv "$vUserName" /Users/"$vUserName"/Documents
chown -Rv "$vUserName" /Users/"$vUserName"/Movies
chown -Rv "$vUserName" /Users/"$vUserName"/Music
chown -Rv "$vUserName" /Users/"$vUserName"/Pictures
chown -Rv "$vUserName" /Users/"$vUserName"/Downloads
chown -Rv "$vUserName" /Users/"$vUserName"/Desktop
chown -Rv "$vUserName" /Users/"$vUserName"/Public

# change permission to new user
chmod -Rv u=rwX /Users/"$vUserName"/Documents
chmod -Rv u=rwX /Users/"$vUserName"/Movies
chmod -Rv u=rwX /Users/"$vUserName"/Music
chmod -Rv u=rwX /Users/"$vUserName"/Pictures
chmod -Rv u=rwX /Users/"$vUserName"/Downloads
chmod -Rv u=rwX /Users/"$vUserName"/Desktop
chmod -Rv u=rwX /Users/"$vUserName"/Public

# remove permissions from everyone else
chmod -Rv go-rwX /Users/"$vUserName"/Documents
chmod -Rv go-rwX /Users/"$vUserName"/Movies
chmod -Rv go-rwX /Users/"$vUserName"/Music
chmod -Rv go-rwX /Users/"$vUserName"/Pictures
chmod -Rv go-rwX /Users/"$vUserName"/Downloads
chmod -Rv go-rwX /Users/"$vUserName"/Desktop
chmod -Rv go-rwX /Users/"$vUserName"/Public
