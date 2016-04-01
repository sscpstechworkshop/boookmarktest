
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

#####################################################################################
# defining variables specific to scenario being used.
#####################################################################################
# define script name, used in log file name creation & working folders/mounts
vScriptName="BACKUP_rsync_windows"
# define where all log files go, name varies on server/directory
vLogPath="/Volumes/Backups/SSCPS-Backups/LogFiles/"
# define location of mount point, with Mac OS X, you probably won't change this
vMountPath='/Volumes/Backups/'
# define location of file containing info for what to exclude
vExclusionFileFullPath="/full/path/including/file/name/file_exclusions.txt"
# define the task to be performed.  either "backup" or "restore"
vTaskToExecute="backup"

# define array for what to backup
#   "fields" = FQDN of server, share on server, folder in share
#   e.g. fileserver1.example.com,hopefullyhiddenshare$,tpsreports
#   NOTES:  mount command does not like passing user/password, "hard-coded" below
vBackupItemsArray[0]="server01.google.com,backup-files$,backuptest1"
vBackupItemsArray[1]="server01.google.com,backup-files$,backuptest2"
vBackupItemsArray[2]="server02.google.com,backup-files$,backuptest1"
vBackupItemsArray[3]="server02.google.com,backup-apps$,backupthisapp"



#####################################################################################
# defining global variables.  they probably won't need to be changed
#####################################################################################
# Setup Date/Time variables - mostly for logging
vDateTimeYear=`date +%Y`
vDateTimeMonth=`date +%m`
vDateTimeDay=`date +%d`
vDateTimeHour=`date +%H`
vDateTimeMin=`date +%M`
vDateTimeSec=`date +%S`
vDateTimeYYYYMMDDHHMMSS=$vDateTimeYear$vDateTimeMonth$vDateTimeDay$vDateTimeHour$vDateTimeMin$vDateTimeSec

# variable for mounting
vBackupMountPoint="$vScriptName"


#####################################################################################
# generic processing, mostly making all is ready for backup loop
#####################################################################################
mkdir -p "$vLogPath"


#####################################################################################
# now step through array and perform each backup
##########################################################################################
for i in "${vBackupItemsArray[@]}"
do
    echo "###################################"
    echo "working on "$i
    # variable extraction 
    IFS=',' read vSourceServerName vSourceShareName vSourceDirectoryName <<< "$i"
    # build working variables
    vSourceServerNameShort=${vSourceServerName%%.*} # was $vBackupServerShort
    vLogFileOutputFullPathName="$vLogPath""/""$vScriptName"-"$vSourceServerName"-"$vSourceDirectoryName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
    vLogFileErrorFullPathName="$vLogPath""/""$vScriptName"-"$vSourceServerName"-"$vSourceDirectoryName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
    vBackupMountFullPath="$vMountPath""$vBackupMountPoint"

    # output start of backup to log file
    vNowMessage=`date` " - Starting backup for: "$i
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

    # mount remote filesystem
    # rsync filesystem to destination
    # unmount filesystem

    # output end of backup to log file
    vNowMessage=`date` " - Ending backup for: "$i
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

done


#####################################################################################
# everything below is from old style backup script, left so can cherry pick code
#####################################################################################

# setup backup location variables
# old variable || vBackupMountPoint="BACKUP_appserver01"
# old variable || vBackupServer="appserver01.ad.sscps.org"
# old variable || vBackupShare="backup"
# old variable || vBackupDestination="/Volumes/Backups/SSCPS-Backups/Apps/""$vBackupServerShort""/"

# Finish building variables that probably won't change config for new server
# old variable || vBackupMountFullPath='/Volumes/Backups/'"$vBackupMountPoint"
# old variable || vLogFileOutput="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
# old variable || vLogFileOutputFullPath="$vLogPath""/""$vLogFileOutput"
# old variable || vLogFileError="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
# old variable || vLogFileErrorFullPath="$vLogPath""/""$vLogFileError"

# mount location, NOTE authentication string fails as variable for some reason
#mkdir "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
# if password has special characters, they need to be html safe, e.g. %23
#/sbin/mount -t smbfs //'ad.example.com;backupuser:password'@"$vBackupServer"/"$vBackupShare" "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# backup Miscellaneous directory
#vBackupDirectory="Miscellaneous"
#rsync -v -v -r -t -W --exclude-from='/Users/automator02/Scripts/file_exclusions.txt' --exclude=\$RECYCLE.BIN --delete --delete-after --log-file="$vLogFileOutputFullPath" -h "$vBackupMountFullPath"/"$vBackupDirectory" "$vBackupDestination" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# unmount location
#/sbin/umount "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
#sleep 5
#if [ -d "$vBackupMountFullPath" ]; then
#     rmdir "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
#fi

#write start of process
#vNowMessage="Finished backup:  "`date`
#echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
