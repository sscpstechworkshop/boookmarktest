#!/usr/bin/env bash
# Bash skips errors and resumes by default

# set tempfolder for mounting
vTempMountPoint=~/TempMnt/
mkdir -p $vTempMountPoint

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
rsync -amrtv --delete-before --progress "$vTempMountPoint"Documents ~/
rsync -amrtv --delete-before --progress "$vTempMountPoint"Movies ~/
rsync -amrtv --delete-before --progress "$vTempMountPoint"Music ~/
rsync -amrtv --delete-before --progress "$vTempMountPoint"Pictures ~/
rsync -amrtv --delete-before --progress "$vTempMountPoint"Downloads ~/
rsync -amrtv --delete-before --progress "$vTempMountPoint"Desktop ~/
rsync -amrtv --delete-before --progress "$vTempMountPoint"Public ~/

#unmount folders
umount "$vTempMountPoint"Documents
umount "$vTempMountPoint"Movies
umount "$vTempMountPoint"Music
umount "$vTempMountPoint"Pictures
umount "$vTempMountPoint"Downloads
umount "$vTempMountPoint"Desktop
umount "$vTempMountPoint"Public
