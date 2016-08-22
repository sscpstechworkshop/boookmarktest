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

# create log folder, this also makes folder for other stuff that gets created/downloaded
if [ ! -d $logPath ]; then
    mkdir -p $logPath
    echo "Log path not found, created it." | logger -s > $logFile
else
    # truncate log file so does not fill up computer
    echo "" | logger -s > $logFile
fi

if [ ! -f $confFile ]; then
    #echo "Settings file not found, creating it." | logger -s >> $logFile
    echo $currentDate>$confFile
    echo "Downloading schedule file for $day." | logger -s >> $logFile
    curl -o $scheduleFile $scheduleURL
else
    storedDate=`head -1 $confFile`
    if [ "$currentDate" = "$storedDate" ]; then
        echo "bellschedule_settings.conf file has today's date.   Schedule refresh not needed." | logger -s >> $logFile
    else
        echo $currentDate>$confFile
        curl -o $scheduleFile $scheduleURL
    fi
fi

if [ ! -f $mp3File ]; then
    echo "MP3 not found, downloading" | logger -s >> $logFile
    curl -o $mp3File $mp3URL
else
    echo "MP3 file found, no need to download" | logger -s >> $logFile
fi

echo "Sleeping for 5 seconds" | logger -s >> $logFile
# Give the possible download(s) a moment to finish
sleep 5   # 5 seconds
#echo "Done sleeping for 5 seconds" | logger -s >> $logFile

#echo "Checking if scheduleFile exists" | logger -s >> $logFile
# populate scheduleArray from scheduleFile
if [ ! -f $scheduleFile ]; then
    echo "$scheduleFile doesn't exist!   Exiting." | logger -s >> $logFile
    exit 1;
else
    #echo "Found $scheduleFile" | logger -s >> $logFile
    #IFS=','
    IFS=$'\r\n' GLOBIGNORE='*'
    scheduleArray=(`cat $scheduleFile`)
fi

#echo "Before loop that finds bell schedule" | logger -s >> $logFile
for i in ${scheduleArray[@]}; do
    echo "Line being tested is: $i" | logger -s >> $logFile
    #IFS=','
    #currentTimeArray=(`cat $i`)
    IFS=', ' read -r -a currentTimeArray <<< $i
    #echo "currentTimeArray is: ${currentTimeArray[@]}" | logger -s >> $logFile
    if [ "${currentTimeArray[0]}" = "default" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        echo "Using default bellScheduleArray: ${bellScheduleArray[@]}" | logger -s >> $logFile
        unset bellScheduleArray[0]
    fi
    #echo "Current date is: $currentDate" | logger -s >> $logFile
    if [ "${currentTimeArray[0]}" = "$currentDate" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        echo "Changing to custom bellScheduleArray: ${bellScheduleArray[@]}" | logger -s >> $logFile
        unset bellScheduleArray[0]
    fi
done

echo "Final bellSchedule array is: ${bellScheduleArray[@]}" | logger -s >> $logFile

# if bellSchedule has no times, exit
if [ ${#bellScheduleArray[@]} -eq 0 ]; then
     echo "Schedule has no times.  Exiting." | logger -s >> $logFile
     exit 0;
fi

for time in ${bellScheduleArray[@]}; do
    #echo "Time comparison is on : time=$time  currentTime=$currentTime" | logger -s >> $logFile
    if [ "$time" = "$currentTime" ]; then
        # set volume to 50%
        osascript -e "set volume 4"
        afplay $mp3File
        exit 0;
    fi
done
