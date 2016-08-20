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

# create log folder
mkdir -p /Users/Shared/BellSchedule/logs

if [ ! -f /Users/Shared/BellSchedule/bellschedule_settings.conf ]; then
    mkdir -p /Users/Shared/BellSchedule/
    echo $currentDate>bellschedule_settings.conf
    curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf 'http://files.sscps.org/<location>/bellschedule_$day.conf'
else
    storedDate=`head -1 /Users/Shared/BellSchedule/bellschedule_settings.conf`
    if [ "$currentDate" = "$storedDate" ]; then
        echo "bellschedule_settings.conf file has today's date.   Exiting." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
        exit 0;
    else
        curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf 'http://files.sscps.org/<location>/bellschedule_$day.conf'
    fi
fi

if [ ! -f /Users/Shared/BellSchedule/school_bell.mp3 ]; then
    curl -o /Users/Shared/BellSchedule/school_bell.mp3 'http://files.sscps.org/<location>/school_bell.mp3'

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
    if [ "$i" = "default" ]; then
        bellSchedule=${scheduleArray[$i]}
    fi
    if [ "$i" = "$currentDate" ]; then
        bellSchedule=${scheduleArray[$i]}
    fi
done

# remove date element (should be first) from schedule array
unset bellSchedule[0]

# if bellSchedule has no times, exit
if [ ${#bellSchedule[@]} -eq 0 ]; then
     echo "Schedule has no times.  Exiting." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
     exit 0;
fi

for time in ${bellSchedule[@]}; do
    if [ "$time" = "$currentTime" ]; then
        # set volume to 50%
        osascript -e "set volume 4"
        afplay /Users/Shared/BellSchedule/school_bell.mp3
        exit 0;
    fi
done



    


