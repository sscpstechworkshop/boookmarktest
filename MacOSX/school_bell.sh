################################################################################
# Placeholder for school bell ring script
# Mac images have school_bell.mp3 located at /Users/Shared
################################################################################

# Check if /Users/Shared/BellSchedule/bellschedule_settings.conf exists
# if not, create it and populate today's date in it, otherwise read the date from it
if [ ! -f /Users/Shared/BellSchedule/bellschedule_settings.conf ]; then
    echo "bellschedule_settings.conf file not found!   Creating it and populating with current date." | logger -s >> /Users/Shared/BellSchedule/logs/bellschedule.log
    mkdir -p /Users/Shared/BellSchedule
    echo `date "+%Y/%m/%d"`>/Users/Shared/BellSchedule/bellschedule_settings.conf
else
    # (file exists) 
    # TODO: compare today's date with date already in bellschedule_settings.conf and exit if they match
fi

# conf file exists and the date is not today, so we need to grab the schedule file

# Today's date and time
day=`date "+%A"`
hour=`date "+%H"`
minute=`date "+%M+`

# get today's bell schedule
curl -o /Users/Shared/BellSchedule/bellschedule_$day.conf 'http://files.sscps.org/<location>/bellschedule_$day'
todaySchedule=/Users/Shared/BellSchedule/bellschedule_$day.conf

# populate array with file
scheduleArray=(`cat $todaySchedule`)
# first line in todaySchedule will be ${scheduleArray[0]}
# second line in todaySchedule is ${scheduleArray[1]}
# and so on

# first line (standard schedule)
# example: 00/00/0000,8:15,8:18,8:23,9:09,9:52,9:55,10:38,10:40,11:05,11:08,11:51,11:54,12:37

# following lines in file are exception days
# example: 05/06/2016,8:15,8:18,8:28,9:06,9:09,9:47,9:50,9:57,10:00,10:38,10:41,11:19,11:22,12:00

# put system volume at about 50 percent
osascript -e "set volume 4"

# sound the bell and/or exit




