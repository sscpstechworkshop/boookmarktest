################################################################################
# School bell script
# This script will check for /Users/Shared/BellSchedule/bellschedule_settings.conf
# containing a bell schedule.  This file MUST be present.  If not dated today
# it will download the bell schedule.
# This script is being called every minute by the /Library/LaunchAgents/school_bell.plist file
# Mac images should have school_bell.mp3 located at /Users/Shared/BellSchedule
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

if [ ! -f /Users/Shared/BellSchedule/bellschedule_settings.conf ]; then
    mkdir -p /Users/Shared/BellSchedule/
    echo $currentDate>bellschedule_settings.conf
    curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf 'http://files.sscps.org/<location>/bellschedule_$day'
else
    storedDate=`head -1 /Users/Shared/BellSchedule/bellschedule_settings.conf`
    if [ "$currentDate" = "$storedDate" ]; then
        echo "bellschedule_settings.conf file has today's date.   Exiting." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
        exit 0;
    else
        curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf 'http://files.sscps.org/<location>/bellschedule_$day'
    fi
fi

# Give the possible download a moment to finish
sleep 5

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



# build individual schedule arrays (scheduleFile should have exactly 4 lines?)
# first line in scheduleFile will be default schedule
# IFS=',' read -ra defaultSchedule <<< "${scheduleArray[0]}"

# second line in scheduleFile is first exceptions
# IFS=',' read -ra exceptionSchedule1 <<< "${scheduleArray[1]}"

# third line in scheduleFile is second exceptions
# IFS=',' read -ra exceptionSchedule2 <<< "${scheduleArray[2]}"

# fourth line in scheduleFile is third exceptions
# IFS=',' read -ra exceptionSchedule3 <<< "${scheduleArray[3]}"

# Match current date with exception dates to see if we are not on default schedule
# if [ "${exceptionsSchedule1[0]}" = "$currentDate" ]; then
#    activeSchedule=("${exceptionSchedule1[@]}")
# else if [ "${exceptionsSchedule2[0]}" = "$currentDate" ]; then
#    activeSchedule=("${exceptionSchedule2[@]}")
# else if [ "${exceptionsSchedule3[0]}" = "$currentDate" ]; then
#     activeSchedule=("${exceptionSchedule3[@]}")
# else
#     activeSchedule=("${defaultSchedule[@]}")
    
# if activeSchedule array only has 1 element (e.g. it's Christmas) exit script
# if [ ${#activeSchedule[@]} -eq 1 ]; then
#     echo "activeSchedule has no times.  Exiting." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
#     exit 0;
# fi



    


