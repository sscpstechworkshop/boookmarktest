#!/usr/bin/env bash
# Bash skips errors and resumes by default
# 
# script is to copy user's files from AD File server to local mac.  
# "companion" script then moves those files to the local profile after login

# set tempfolder for mounting
vTempMountPoint=~/TempMnt/
mkdir -p $vTempMountPoint

# set folder to store data until laptop deployed
vTempDestination=/Users/Shared/<username>/
mkdir -p $vTempDestination

# set everything up, don't forget to manually enter home folder location
#vHomeFolder="\\\\<adminuser>@<server>\\FacStaffUserFiles\\<username>\\"

# mount all the folders
mount -t smbfs $vHomeFolder/Documents "$vTempMountPoint"Documents
mkdir -p "$vTempMountPoint"Movies
mount -t smbfs $vHomeFolder/Movies "$vTempMountPoint"Movies
mkdir -p "$vTempMountPoint"Music
mount -t smbfs $vHomeFolder/Music "$vTempMountPoint"Music
mkdir -p "$vTempMountPoint"Pictures
mount -t smbfs $vHomeFolder/Pictures "$vTempMountPoint"Pictures
mkdir -p "$vTempMountPoint"Downloads
mount -t smbfs $vHomeFolder/Downloads "$vTempMountPoint"Downloads
mkdir -p "$vTempMountPoint"Desktop
mount -t smbfs $vHomeFolder/Desktop "$vTempMountPoint"Desktop
mkdir -p "$vTempMountPoint"Public
mount -t smbfs $vHomeFolder/Public "$vTempMountPoint"Public

#do rsync stuff
#ls -hl "$vTempMountPoint"Documents
rsync -amrtv --delete-before --progress "$vTempMountPoint"Documents "$vTempDestination"
rsync -amrtv --delete-before --progress "$vTempMountPoint"Movies "$vTempDestination"
rsync -amrtv --delete-before --progress "$vTempMountPoint"Music "$vTempDestination"
rsync -amrtv --delete-before --progress "$vTempMountPoint"Pictures "$vTempDestination"
rsync -amrtv --delete-before --progress "$vTempMountPoint"Downloads "$vTempDestination"
rsync -amrtv --delete-before --progress "$vTempMountPoint"Desktop "$vTempDestination"
rsync -amrtv --delete-before --progress "$vTempMountPoint"Public "$vTempDestination"

#unmount folders
umount "$vTempMountPoint"Documents
umount "$vTempMountPoint"Movies
umount "$vTempMountPoint"Music
umount "$vTempMountPoint"Pictures
umount "$vTempMountPoint"Downloads
umount "$vTempMountPoint"Desktop
umount "$vTempMountPoint"Public
