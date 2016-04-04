#! /bin/bash
##########################################################################################
#
# Script Name:    backup_rsync_windows.sh
# Script Usage:   This script will walk through an array of Windows Servers to backup
#
#                 You will probably want to do the following:
#                   1.  change is the scriptname,
#                   2.  adjust adjust list of server FQDNs & shares,
#                   3.  adjust other paths if you don't like them.
#
# Script Notes:   Assumed that server/share/directory will be backed up to
#                   server/share-directory, located in defined backup location (only one).
#                 Assumed restore is everything to origin location. If you need something
#                   else, you're on your own.
#                 Assumed restore should not clobber existing newer files
#
# Script Updates: 201603301224 - Ralph deGennaro - First added boilerplate stuff.
#                 201603301521 - Ralph deGennaro - Started variables to be used.
#                 201604011658 - Ralph deGennaro - More variables, started loop.
#                 201604041233 - Ralph deGennaro - Finished loop, cleaned up variables.
#
##########################################################################################


##########################################################################################
# defining variables specific to scenario being used.
##########################################################################################
# define script name, used in log file name creation & working folders/mounts
vScriptName="BACKUP_rsync_windows"
# define where all log files go, name varies on server/directory
vLogPath="/Volumes/Backups/SSCPS-Backups-Test/LogFiles/"
# location filesystems will be mounted, sub-folder is $vScriptName/server_directory
vMountPath='/Volumes/Backups/mounts/'
# location filesystems will be duplicated to, folder for each backup is server/directory
vBackupPath='/Volumes/Backups/SSCPS-Backups-Test/'
# define location of file containing info for what to exclude
#vExclusionFileFullPath="/full/path/including/file/name/file_exclusions.txt"
vExclusionFileFullPath="/Users/automator02/Scripts/file_exclusions.txt"
# define the task to be performed.  either "backup" or "restore"
vTaskToExecute="backup"

# define array for what to backup
#   "fields" = FQDN of server, share on server, directory in share
#   e.g. fileserver1.example.com,hopefullyhiddenshare$,tpsreports
#   NOTES:  mount command does not like passing user/password, "hard-coded" below
vBackupItemsArray[0]="server01.google.com,backup-files$,backuptest1"
vBackupItemsArray[1]="server01.google.com,backup-files$,backuptest2"
vBackupItemsArray[2]="server02.google.com,backup-files$,backuptest1"
vBackupItemsArray[3]="server02.google.com,backup-apps$,backupthisapp"


##########################################################################################
# defining global variables.  they probably won't need to be changed
##########################################################################################
# Setup Date/Time variables - mostly for logging
vDateTimeYear=`date +%Y`
vDateTimeMonth=`date +%m`
vDateTimeDay=`date +%d`
vDateTimeHour=`date +%H`
vDateTimeMin=`date +%M`
vDateTimeSec=`date +%S`
vDateTimeYYYYMMDDHHMMSS=$vDateTimeYear$vDateTimeMonth$vDateTimeDay$vDateTimeHour$vDateTimeMin$vDateTimeSec


##########################################################################################
# generic processing, mostly making all is ready for backup loop
##########################################################################################
mkdir -p "$vLogPath"
mkdir -p "$vMountPath"
mkdir -p "$vBackupPath"


##########################################################################################
# now step through array and perform each backup
##########################################################################################
for i in "${vBackupItemsArray[@]}"
do
    #echo "###################################"
    #echo "working on "$i
    # variable extraction for specifics of backup
    IFS=',' read vSourceServerName vSourceShareName vSourceDirectoryName <<< "$i"
    # build working variables
    vSourceServerNameShort=${vSourceServerName%%.*} # was $vBackupServerShort
    vLogFileOutputFullPathName="$vLogPath""/""$vScriptName"-"$vSourceServerNameShort"-"$vSourceDirectoryName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
    vLogFileErrorFullPathName="$vLogPath""/""$vScriptName"-"$vSourceServerNameShort"-"$vSourceDirectoryName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
    vBackupMountFullPath="$vMountPath""/""$vSourceServerNameShort"-"$vSourceShareName"
    vBackupDestination="$vBackupPath""/""$vSourceServerNameShort""/""$vSourceShareName"-"$vSourceDirectoryName"

    # output start of backup to log file
    vNowMessage=`date` " - Starting backup for: "$i
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

    # mount location, NOTE authentication string fails as variable for some reason
    mkdir -p "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    # if password has special characters, they need to be html safe, e.g. %23
    /sbin/mount -t smbfs //'some.domain.com;backupuser:password'@"$vSourceServerName"/"$vSourceShareName" "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

    # rsync filesystem to destination
    rsync -v -v -r -t -W --exclude-from="$vExclusionFileFullPath" --exclude=\$RECYCLE.BIN --delete --delete-after --log-file="$vLogFileOutputFullPath" -h "$vBackupMountFullPath"/"$vSourceDirectoryName" "$vBackupDestination" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

    # unmount filesystem
    /sbin/umount "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    sleep 5
    if [ -d "$vBackupMountFullPath" ]; then
         rmdir "$vBackupMountFullPath" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    fi

    # output end of backup to log file
    vNowMessage=`date` " - Ending backup for: "$i
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
    echo "##########################################################################################" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

done
