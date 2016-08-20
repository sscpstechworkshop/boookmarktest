################################################################################
# School bell ring script
# Mac images should have school_bell.mp3 located at /Users/Shared/BellSchedule
################################################################################

# Check if /Users/Shared/BellSchedule/bellschedule_settings.conf exists
# if not, create it and populate today's date in it, otherwise read the date from it
if [ ! -f /Users/Shared/BellSchedule/bellschedule_settings.conf ]; then
    echo "bellschedule_settings.conf file not found!   Creating it and populating with current date." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    mkdir -p /Users/Shared/BellSchedule
    echo `date "+%Y/%m/%d"`>/Users/Shared/BellSchedule/bellschedule_settings.conf
else
    # (config file exists) 
    # TODO: compare today's date with date already in bellschedule_settings.conf and exit if they match
fi

# conf file exists and the date is not today, so we need to grab the schedule file

# Today's date and time
year=`date "+%Y"`       # 2016
month=`date "+%m"`      # 08
dayOfMonth=`date "+%d"` # 20
day=`date "+%A"`        # Friday
hour=`date "+%H"`       # 15 (24hr format)
minute=`date "+%M"`     # 45 

# get today's bell schedule
curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf 'http://files.sscps.org/<location>/bellschedule_$day'
scheduleFile=/Users/Shared/BellSchedule/bellschedule_$day.conf

# populate scheduleArray from scheduleFile
scheduleArray=(`cat $scheduleFile`)

# build individual schedule arrays (scheduleFile should have exactly 4 lines?)
# first line in scheduleFile will be default schedule
IFS=',' read -ra defaultSchedule <<< "${scheduleArray[0]}"

# second line in scheduleFile is first exceptions
IFS=',' read -ra exceptionSchedule1 <<< "${scheduleArray[1]}"

# third line in scheduleFile is second exceptions
IFS=',' read -ra exceptionSchedule2 <<< "${scheduleArray[2]}"

# fourth line in scheduleFile is third exceptions
IFS=',' read -ra exceptionSchedule3 <<< "${scheduleArray[3]}"

# Match current date with exception dates to see if we are not on default schedule
if [ "${exceptionsSchedule1[0]}" = "$month/$dayOfMonth/$year" ]; then
    activeSchedule=("${exceptionSchedule1[@]}")
else if [ "${exceptionsSchedule2[0]}" = "$month/$dayOfMonth/$year" ]; then
    activeSchedule=("${exceptionSchedule2[@]}")
else if [ "${exceptionsSchedule3[0]}" = "$month/$dayOfMonth/$year" ]; then
    activeSchedule=("${exceptionSchedule3[@]}")
else
    activeSchedule=("${defaultSchedule[@]}")
    
# We've decided what schedule to use.  Loop through it and look for matching times

# first, we need to make sure system volume isn't muted
# this puts volume at about 50 percent
osascript -e "set volume 4"

for time in ${activeSchedule[@]}; do
    if [ "$time" = "${activeSchedule[@]}" ]; then    # TODO check for future times and exit if found
        afplay /Users/Shared/BellSchedule/school_bell.mp3
        exit 0;
done
    


