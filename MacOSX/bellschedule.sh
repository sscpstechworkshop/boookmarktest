################################################################################
# School bell script
#
# This script is being called every minute by the /Library/LaunchAgents/school_bell.plist file
################################################################################

# Today's date and time
year=`date "+%Y"`       # 2016
month=`date "+%m"`      # 08
dayOfMonth=`date "+%d"` # 20
day=`date "+%A"`        # Friday
hour=`date "+%H"`       # 15 (24hr format)
minute=`date "+%M"`     # 45
currentDate=$month/$dayOfMonth/$year
currentTime=$hour:$minute
#versionRemoteDir=joetest
#versionRemoteDir=riotest
versionRemoteDir=v1
confFile=/Users/Shared/BellSchedule/bellschedule_settings.conf
scheduleURL=http://files.sscps.org/bellschedule/$versionRemoteDir/bellschedule_$day.conf
scheduleFile=/Users/Shared/BellSchedule/bellschedule_$day.conf
mp3URL=http://files.sscps.org/bellschedule/$versionRemoteDir/bellschedule.mp3
mp3File=/Users/Shared/BellSchedule/bellschedule.mp3
logPath=/Users/Shared/BellSchedule/logs/
logFile=$logPath'bellschedule.log'
# the higher the number, the more the information, read below for details
logLevel=5

function sendToLog {
    if [ $2 -le $logLevel ]; then
        message="$currentDate $currentTime: $1"
        logger -s $message
        echo $message >> $logFile
    fi
}

# create log folder, this also makes folder for other stuff that gets created/downloaded
if [ ! -d $logPath ]; then
    mkdir -p $logPath
#else
    # truncate log file so does not fill up computer
    # sendToLog ""
fi

sendToLog "Start script" 0

if [ ! -f $confFile ]; then
    sendToLog "Settings file not found, creating it." 2
    echo $currentDate>$confFile
    sendToLog "Downloading schedule file for $day." 1
    curl -o $scheduleFile $scheduleURL
else
    storedDate=`head -1 $confFile`
    if [ "$currentDate" = "$storedDate" ]; then
        sendToLog "bellschedule_settings.conf file has today's date.   Schedule refresh not needed." 1
    else
        echo $currentDate>$confFile
        curl -o $scheduleFile $scheduleURL
    fi
fi

if [ -f $confFile ]; then
    scheduleFileSize=$(wc -c <$scheduleFile)
    if [ $scheduleFileSize -eq 0 ]; then
        sendToLog "Zero sized $scheduleFile, removing $confFile for redownload." 2
        rm -f $confFile
    fi
fi

if [ ! -f $mp3File ]; then
    sendToLog "MP3 not found, downloading..." 2
    curl -o $mp3File $mp3URL
else
    mp3FileSize=$(wc -c <$mp3File)
    if [ $mp3FileSize -eq 0 ]; then
        sendToLog "Zero sized $mp3File, redownload." 2
        curl -o $mp3File $mp3URL
    else
        sendToLog "MP3 file found & non-zero, no need to download." 3
    fi
fi

sendToLog "Sleeping for 5 seconds" 4
# Give the possible download(s) a moment to finish
sleep 5   # 5 seconds
sendToLog "Done sleeping for 5 seconds" 4

# populate scheduleArray from scheduleFile
sendToLog "Checking if scheduleFile exists" 5
if [ ! -f $scheduleFile ]; then
    sendToLog "$scheduleFile doesn't exist!   Exiting." 0
    exit 1;
else
    sendToLog "Found $scheduleFile" 5
    IFS=$'\r\n' GLOBIGNORE='*'
    scheduleArray=(`cat $scheduleFile`)
fi

sendToLog "Before loop that finds bell schedule" 5
for i in ${scheduleArray[@]}; do
    sendToLog "Line being tested is: $i" 4
    IFS=',' read -r -a currentTimeArray <<< "$i"
    sendToLog "currentTimeArray is: ${currentTimeArray[*]}" 5
    if [ "${currentTimeArray[0]}" = "default" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        sendToLog "Using default bellScheduleArray: ${bellScheduleArray[*]}" 1
        unset bellScheduleArray[0]
    fi
    sendToLog "Current date is: $currentDate" 5
    if [ "${currentTimeArray[0]}" = "$currentDate" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        sendToLog "Changing to custom bellScheduleArray: ${bellScheduleArray[*]}" 1
        unset bellScheduleArray[0]
    fi
done

sendToLog "Final bellSchedule array is: ${bellScheduleArray[*]}" 0

# if bellSchedule has no times, exit
if [ ${#bellScheduleArray[@]} -eq 0 ]; then
     sendToLog "Schedule has no times.  Exiting." 0
     exit 0;
fi

for time in ${bellScheduleArray[@]}; do
    sendToLog "Time comparison is between : time=$time currentTime=$currentTime" 4
    if [ "$time" = "$currentTime" ]; then
        # set volume to 50%
        osascript -e "set volume 5"
        afplay $mp3File
        exit 0;
    fi
done
