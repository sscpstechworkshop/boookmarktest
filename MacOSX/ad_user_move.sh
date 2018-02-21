#!/usr/bin/env bash
# Bash skips errors and resumes by default
# 
# script is to copy user's files copied with "companion" script from temp storage to user's folders

# set username variable
vUserName="<username>"

# set folder that is storing user files 
vTempSource=/Users/Shared/"$vUserName"/

#rsync -amrtv --delete-before --progress "$vTempSource"Documents ~/
#rsync -amrtv --delete-before --progress "$vTempSource"Movies ~/
#rsync -amrtv --delete-before --progress "$vTempSource"Music ~/
#rsync -amrtv --delete-before --progress "$vTempSource"Pictures ~/
#rsync -amrtv --delete-before --progress "$vTempSource"Downloads ~/
#rsync -amrtv --delete-before --progress "$vTempSource"Desktop ~/
#rsync -amrtv --delete-before --progress "$vTempSource"Public ~/

# Move files
mv "$vTempSource"Documents/* ~/Documents
mv "$vTempSource"Movies/* ~/Movies
mv "$vTempSource"Music/* ~/Music
mv "$vTempSource"Pictures/* ~/Pictures
mv "$vTempSource"Downloads/* ~/Downloads
mv "$vTempSource"Desktop/* ~/Desktop
mv "$vTempSource"Public/* ~/Public

# Change owner from sscpslocal to user
chown -Rv "$vUserName" ~/Documents
chown -Rv "$vUserName" ~/Movies
chown -Rv "$vUserName" ~/Music
chown -Rv "$vUserName" ~/Pictures
chown -Rv "$vUserName" ~/Downloads
chown -Rv "$vUserName" ~/Desktop
chown -Rv "$vUserName" ~/Public

# change permission to new user
chmod -Rv u=rwX ~/Documents
chmod -Rv u=rwX ~/Movies
chmod -Rv u=rwX ~/Music
chmod -Rv u=rwX ~/Pictures
chmod -Rv u=rwX ~/Downloads
chmod -Rv u=rwX ~/Desktop
chmod -Rv u=rwX ~/Public

# remove permissions from everyone else
chmod -Rv go-rwX ~/Documents
chmod -Rv go-rwX ~/Movies
chmod -Rv go-rwX ~/Music
chmod -Rv go-rwX ~/Pictures
chmod -Rv go-rwX ~/Downloads
chmod -Rv go-rwX ~/Desktop
chmod -Rv go-rwX ~/Public
