#! /bin/bash
#################################################################################################
#
# Script Name:    _backup_joomlawebsite.sh
# Script Usage:   This script is to create a single TAR.GZ file for relevant database and website
#                 data related to SSCPS's test Library website.
#
#                 Basic steps are:
#                   1.  create mysql dump file in directory under working directory
#                   2.  copy website directory to directory under working directory
#                   3.  tar & gz whole directory to storage folder
#                   4.  remove working directory
#
#                 You will probably want to do the following:
#                   1.  change is the scriptname, search & replace whole file
#                   2.  adjust other variables for database & website location.
#
# Script Updates:
#     201407141130 - rdegennaro@sscps.org - First added boilerplate stuff.
#     201407301211 - rdegennaro@sscps.org - Converted template to current purpose.
#
#################################################################################################

# Setup variables changed for script
vScriptName="_backup_joomlawebsite.sh"

# MySQL information
vMySQLUser=""
vMySQLPassword=""
vMySQLHost=""
vMySQLDB=""
vWWWSiteDir=""
vBackupPath=""

# Setup Date/Time variables.  Probably won't have to change.
vDateTimeYear=`date +%Y`
vDateTimeMonth=`date +%m`
vDateTimeDay=`date +%d`
vDateTimeHour=`date +%H`
vDateTimeMin=`date +%M`
vDateTimeSec=`date +%S`
vDateTimeYYYYMMDDHHMMSS=$vDateTimeYear$vDateTimeMonth$vDateTimeDay$vDateTimeHour$vDateTimeMin$vDateTimeSec
# Finish building log variables
vLogPath="/var/log/$vScriptName"
vLogFileOutput="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
vLogFileOutputFullPath="$vLogPath""/""$vLogFileOutput"
vLogFileError="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
vLogFileErrorFullPath="$vLogPath""/""$vLogFileError"

# Now do some initial setup
mkdir -p "$vLogPath"

#write start of process
vNowMessage="Starting the process:  "`date`
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# NOW DO STUFF!!!  :-)
# setup directories
vBackupName="$vMySQLDB""-""$vDateTimeYYYYMMDDHHMMSS"
vBackupWorkingDir="$vBackupPath""/working/""$vBackupName"
mkdir -p "$vBackupWorkingDir"
vBackupDestinationDir="$vBackupPath""/""$vMySQLDB"
mkdir -p "$vBackupDestinationDir"

# set default permissions
umask 177
# dump database to working directory
/usr/bin/mysqldump --user="$vMySQLUser" --password="$vMySQLPassword" --host="$vMySQLHost" "$vMySQLDB" > "$vBackupWorkingDir""/""$vMySQLDB"".sql"
# copy joomla website directory to working directory
/bin/cp -ar "$vWWWSiteDir" "$vBackupWorkingDir""/"
cd "$vBackupWorkingDir"
cd ..
# tar & gz everything from name of working directory to backup location
/bin/tar czvf "$vBackupDestinationDir""/""$vBackupName"".tar.gz" "$vBackupWorkingDir"
# clearnup
rm -R "$vBackupWorkingDir"

#write end of process
vNowMessage="Finished backup:  "`date`
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# cleanup older log files until do rolling log file by removing anything older 30 days
vDateInPastYear=`date +%Y --date="-30 day"`
vDateInPastMonth=`date +%m --date="-30 day"`
vDateInPastDay=`date +%d --date="-30 day"`
vDateInPast="$vDateInPastYear""$vDateInPastMonth""$vDateInPastDay"
find "$vLogPath" ! -newermt "$vDateInPast" -type f -print0 | xargs -0 rm
