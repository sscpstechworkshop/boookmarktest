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
confFile=/Users/Shared/BellSchedule/bellschedule_settings.conf
scheduleURL=http://files.sscps.org/bellschedule/v1/bellschedule_$day.conf
scheduleFile=/Users/Shared/BellSchedule/bellschedule_$day.conf
mp3URL=http://files.sscps.org/bellschedule/v1/bellschedule.mp3
mp3File=/Users/Shared/BellSchedule/bellschedule.mp3
logPath=/Users/Shared/BellSchedule/logs/
logFile=$logPath'bellschedule.log'

function sendToLog {
    message="$currentDate $currentTime: $1"
    logger -s $message
    echo $message >> $logFile
}

# create log folder, this also makes folder for other stuff that gets created/downloaded
if [ ! -d $logPath ]; then
    mkdir -p $logPath
#else
    # truncate log file so does not fill up computer
    # sendToLog ""
fi

sendToLog "Start script"

if [ ! -f $confFile ]; then
    sendToLog "Settings file not found, creating it."
    echo $currentDate>$confFile
    sendToLog "Downloading schedule file for $day."
    curl -o $scheduleFile $scheduleURL
else
    storedDate=`head -1 $confFile`
    if [ "$currentDate" = "$storedDate" ]; then
        sendToLog "bellschedule_settings.conf file has today's date.   Schedule refresh not needed."
    else
        echo $currentDate>$confFile
        curl -o $scheduleFile $scheduleURL
    fi
fi

if [ -f $confFile ]; then
    scheduleFileSize=$(wc -c <$scheduleFile)
    if [ $scheduleFileSize -eq 0 ]; then
        sendToLog "Zero sized $scheduleFile, removing $confFile for redownload."
        rm -f $confFile
    fi
fi

if [ ! -f $mp3File ]; then
    sendToLog "MP3 not found, downloading..."
    curl -o $mp3File $mp3URL
else
    mp3FileSize=$(wc -c <$mp3File)
    if [ $mp3FileSize -eq 0 ]; then
        sendToLog "Zero sized $mp3File, redownload."
        curl -o $mp3File $mp3URL
    else
        sendToLog "MP3 file found & non-zero, no need to download."
    fi
fi

sendToLog "Sleeping for 5 seconds"
# Give the possible download(s) a moment to finish
sleep 5   # 5 seconds
#sendToLog "Done sleeping for 5 seconds"

#sendToLog "Checking if scheduleFile exists"
# populate scheduleArray from scheduleFile
if [ ! -f $scheduleFile ]; then
    sendToLog "$scheduleFile doesn't exist!   Exiting."
    exit 1;
else
    #sendToLog "Found $scheduleFile"
    #IFS=','
    IFS=$'\r\n' GLOBIGNORE='*'
    scheduleArray=(`cat $scheduleFile`)
fi

#sendToLog "Before loop that finds bell schedule"
for i in ${scheduleArray[@]}; do
    sendToLog "Line being tested is: $i"
    #IFS=','
    #currentTimeArray=(`cat $i`)
    IFS=', ' read -r -a currentTimeArray <<< $i
    #sendToLog "currentTimeArray is: ${currentTimeArray[@]}"
    if [ "${currentTimeArray[0]}" = "default" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        sendToLog "Using default bellScheduleArray: ${bellScheduleArray[@]}"
        unset bellScheduleArray[0]
    fi
    #sendToLog "Current date is: $currentDate"
    if [ "${currentTimeArray[0]}" = "$currentDate" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        sendToLog "Changing to custom bellScheduleArray: ${bellScheduleArray[@]}"
        unset bellScheduleArray[0]
    fi
done

sendToLog "Final bellSchedule array is: ${bellScheduleArray[@]}"

# if bellSchedule has no times, exit
if [ ${#bellScheduleArray[@]} -eq 0 ]; then
     sendToLog "Schedule has no times.  Exiting."
     exit 0;
fi

for time in ${bellScheduleArray[@]}; do
    sendToLog "Time comparison is on : time=$time currentTime=$currentTime"
    if [ "$time" = "$currentTime" ]; then
        # set volume to 50%
        osascript -e "set volume 5"
        afplay $mp3File
        exit 0;
    fi
done
