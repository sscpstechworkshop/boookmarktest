#!/usr/bin/env bash
# Bash skips errors and resumes by default

# manually set home folder
#vHomeFolder="\\<server>\FacStaffUserFiles\<username>\"
vHomeFolder=""
mount -t smbfs $vHomeFolder/Documents ~/Documents
mount -t smbfs $vHomeFolder/Movies ~/Movies
mount -t smbfs $vHomeFolder/Music ~/Music
mount -t smbfs $vHomeFolder/Pictures ~/Pictures
mount -t smbfs $vHomeFolder/Downloads ~/Downloads
mount -t smbfs $vHomeFolder/Desktop ~/Desktop
mount -t smbfs $vHomeFolder/Public ~/Public
