#!/usr/bin/env bash
# Bash skips errors and resumes by default

# set tempfolder for mounting
vTempMountPoint="~/TempMnt/"

# manually set home folder
#vHomeFolder="\\<server>\FacStaffUserFiles\<username>\"
vHomeFolder=""
mount -t smbfs $vHomeFolder/Documents "$vTempMountPoint"Documents
mount -t smbfs $vHomeFolder/Movies "$vTempMountPoint"Movies
mount -t smbfs $vHomeFolder/Music "$vTempMountPoint"Music
mount -t smbfs $vHomeFolder/Pictures "$vTempMountPoint"Pictures
mount -t smbfs $vHomeFolder/Downloads "$vTempMountPoint"Downloads
mount -t smbfs $vHomeFolder/Desktop "$vTempMountPoint"Desktop
mount -t smbfs $vHomeFolder/Public "$vTempMountPoint"Public
