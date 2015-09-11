#! /bin/bash
#####################################################################################
#
# Script Name:    _template_withlogging.sh
# Script Usage:   This is just a template that setups logging, modify if as
#                 needed for other purposes.
#
#                 You will probably want to do the following:
#                   1.  change is the scriptname, search & replace whole file
#                   2.  adjust other paths if you don't like them.
#
# Script Updates: 201407141130 - Ralph deGennaro - First added boilerplate stuff.
#                 201407141547 - Ralph deGennaro - Added nicer header comments.
#
#####################################################################################


#setup logging variables
vScriptName="script_to_do_something.sh"
vLogPath="/LogFiles/$vScriptName"
mkdir -p "$vLogPath"

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
vLogFileOutput="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-output.log
vLogFileOutputFullPath="$vLogPath""/""$vLogFileOutput"
vLogFileError="$vScriptName"-"$vDateTimeYYYYMMDDHHMMSS"-error.log
vLogFileErrorFullPath="$vLogPath""/""$vLogFileError"

#write start of process
vNowMessage="Starting the process:  "`date`
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"

# NOW DO STUFF!!!  :-)

#write end of process
vNowMessage="Finished backup:  "`date`
echo "$vNowMessage" 1>> "$vLogFileOutputFullPath" 2>> "$vLogFileErrorFullPath"
