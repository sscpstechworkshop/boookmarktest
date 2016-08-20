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
scheduleURL=http://files.sscps.org/bellschedule/v1/bellschedule_$day.conf
scheduleFile=/Users/Shared/BellSchedule/bellschedule_$day.conf

# create log folder
if [ ! -d /Users/Shared/BellSchedule/logs ]; then
    mkdir -p /Users/Shared/BellSchedule/logs
fi

if [ ! -f /Users/Shared/BellSchedule/bellschedule_settings.conf ]; then
    echo $currentDate>/Users/Shared/BellSchedule/bellschedule_settings.conf
    curl -o $scheduleFile $scheduleURL
else
    storedDate=`head -1 /Users/Shared/BellSchedule/bellschedule_settings.conf`
    if [ "$currentDate" = "$storedDate" ]; then
        echo "bellschedule_settings.conf file has today's date.   Schedule refresh not needed." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    else
        curl -o $scheduleFile $scheduleURL
    fi
fi

if [ ! -f /Users/Shared/BellSchedule/school_bell.mp3 ]; then
    echo "MP3 not found, downloading" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    curl -o /Users/Shared/BellSchedule/school_bell.mp3 http://files.sscps.org/bellschedule/v1/school_bell.mp3
else
    echo "MP3 file found, no need to download" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
fi

echo "Sleeping for 5 seconds" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
# Give the possible download(s) a moment to finish
sleep 5   # 5 seconds
echo "Done sleeping for 5 seconds" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log

echo "Checking if scheduleFile exists" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
# populate scheduleArray from scheduleFile
if [ ! -f $scheduleFile ]; then
    echo "$scheduleFile doesn't exist!   Exiting." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    exit 1;
else
    echo "Found $scheduleFile" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    IFS=','
    scheduleArray=(`cat $scheduleFile`)
fi

echo "Before loop that finds bell schedule" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
for i in ${scheduleArray[@]}; do
    echo "Line being tested is: $i" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    IFS=','
    currentTimeArray=(`cat $i`)
    echo "currentTimeArray is: $currentTimeArray"
    if [ "${currentTimeArray[0]}" = "default" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")  
        unset bellScheduleArray[0]
    fi
    echo "Current bellScheduleArray is: ${bellScheduleArray[@]}" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    if [ "${currentTimeArray[0]}" = "$currentDate" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        unset bellScheduleArray[0]
    fi
    echo "Current bellScheduleArray is: ${bellScheduleArray[@]}" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log    
done

echo "Final bellSchedule array is: ${bellScheduleArray[@]}" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log

# if bellSchedule has no times, exit
if [ ${#bellScheduleArray[@]} -eq 0 ]; then
     echo "Schedule has no times.  Exiting." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
     exit 0;
fi

for time in ${bellScheduleArray[@]}; do
    echo "Time comparison is on : time=$time  currentTime=$currentTime" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    if [ "$time" = "$currentTime" ]; then
        # set volume to 50%
        osascript -e "set volume 4"
        afplay /Users/Shared/BellSchedule/school_bell.mp3
        exit 0;
    fi
done
