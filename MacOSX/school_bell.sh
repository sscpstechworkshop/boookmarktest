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

# create log folder
if [ ! -d /Users/Shared/BellSchedule/logs ]; then
    mkdir -p /Users/Shared/BellSchedule/logs
fi

if [ ! -f /Users/Shared/BellSchedule/bellschedule_settings.conf ]; then
    echo $currentDate>/Users/Shared/BellSchedule/bellschedule_settings.conf
    curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf $scheduleURL
else
    storedDate=`head -1 /Users/Shared/BellSchedule/bellschedule_settings.conf`
    if [ "$currentDate" = "$storedDate" ]; then
        echo "bellschedule_settings.conf file has today's date.   Schedule refresh not needed." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    else
        curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf $scheduleURL
    fi
fi

if [ ! -f /Users/Shared/BellSchedule/school_bell.mp3 ]; then
    curl -o /Users/Shared/BellSchedule/school_bell.mp3 http://files.sscps.org/bellschedule/v1/school_bell.mp3

# Give the possible download(s) a moment to finish
sleep 5   # 5 seconds

scheduleFile=/Users/Shared/BellSchedule/bellschedule_$day.conf

# populate scheduleArray from scheduleFile
if [ ! -f /Users/Shared/BellSchedule/bellschedule_$day.conf ]; then
    echo "bellschedule_$day.conf doesn't exist!   Exiting." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    exit 1;
else
    IFS=','
    scheduleArray=(`cat $scheduleFile`)
fi

for i in ${scheduleArray[@]}; do
    echo "Line being tested is: $i" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    IFS=','
    currentTimeArray=(`cat $i`)
    if [ "$currentTimeArray[0]" = "default" ]; then
        bellScheduleArray=${currentTimeArray}
        unset bellScheduleArray[0]
    fi
    echo "Current bellScheduleArray is: ${bellScheduleArray[@]}" | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    if [ "$currentTimeArray[0]" = "$currentDate" ]; then
        bellScheduleArray=${currentTimeArray}
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
