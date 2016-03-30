
#! /bin/bash
#####################################################################################
#
# Script Name:    backup_rsync_windows.sh
# Script Usage:   This script will walk through an array of Windows Servers to backup
#
#                 You will probably want to do the following:
#                   1.  change is the scriptname,
#                   2.  adjust adjust list of server FQDNs & shares,
#                   3.  adjust other paths if you don't like them.
#
# Script Notes:   An assumption is that the folder backed up is also the destination.
#                 An assumption is that each server gets its own folder.
#                 An assumption is that each share gets its own folder in the server
#                   folder.
#                 An assumption is restore is everything to same location. If you need
#                   something else, you're on your own.
#                 An assumption is restore won't clobber existing newer files
#
# Script Updates: 201603301224 - Ralph deGennaro - First added boilerplate stuff.
#                 201603301521 - Ralph deGennaro - Started variables to be used.
#
#####################################################################################

# setup logging variables
vScriptName="BACKUP_rsync_windows"
vTaskToExecute="backup"
#vTaskToExecute="restore"
vLogPath="/Volumes/Backups/SSCPS-Backups/LogFiles/"
vBackupMountPoint="BACKUP_working"
#vExclusionFileFullPath="/full/path/including/file/name/file_exclusions.txt"


# array for what to backup
#   these "fields" - FQDN of server, share on server, folder in share
#   e.g. fileserver1.example.com,hopefullyhiddenshare,tpsreports
#   NOTES:  mount command does not like passing user/password, "hard-coded" below
vBackupItemArray[0]="server01.google.com,backup-files$,backuptest1"
vBackupItemArray[1]="server01.google.com,backup-files$,backuptest2"
vBackupItemArray[2]="server02.google.com,backup-files$,backuptest3"
vBackupItemArray[3]="server02.google.com,backup-apps$,backuptest4"

# 



#####################################################################################
# everything below is from old style backup script, left so can cherry pick code
#####################################################################################


mkdir -p "$vLogPath"

#setup backup location variables
vBackupMountPoint=""
vBackupServer=""
vBackupServerShort=${vBackupServer%%.*}
vBackupShare="backup"
vBackupDestination="/Volumes/Backups/SSCPS-Backups/Apps/""$vBackupServerShort""/"

# Setup Date/Time variables
#Probably won't have to change, but needed to build other variables
vDateTimeYear=`date +%Y`
vDateTimeMonth=`date +%m`
vDateTimeDay=`date +%d`
vDateTimeHour=`date +%H`
vDateTimeMin=`date +%M`
vDateTimeSec=`date +%S`
vDateTimeYYYYMMDDHHMMSS=$vDateTimeYear$vDateTimeMonth$vDateTimeDay$vDateTimeHour$vDateTimeMin$vDateTimeSec

#Finish building variables that probably won't change config for new server
vBackupMountFullPath='/Volumes/Backups/'"$vBackupMountPoint"
vLogFileOutput="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
vLogFileOutputFullPath="$vLogPath""/""$vLogFileOutput"
vLogFileError="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
vLogFileErrorFullPath="$vLogPath""/""$vLogFileError"

#write start of process
vNowMessage="Starting backup:  "`date`
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

#mount location, NOTE authentication string fails as variable for some reason
mkdir "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
# if password has special characters, they need to be html safe, e.g. %23
#/sbin/mount -t smbfs //'ad.example.com;backupuser:password'@"$vBackupServer"/"$vBackupShare" "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

#backup Miscellaneous directory
vBackupDirectory="Miscellaneous"
rsync -v -v -r -t -W --exclude-from="$vExclusionFileFullPath" --exclude=\$RECYCLE.BIN --delete --delete-after --log-file="$vLogFileOutputFullPath" -h "$vBackupMountFullPath"/"$vBackupDirectory" "$vBackupDestination" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

#unmount location
/sbin/umount "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
sleep 5
if [ -d "$vBackupMountFullPath" ]; then
     rmdir "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
fi

#write start of process
vNowMessage="Finished backup:  "`date`
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
