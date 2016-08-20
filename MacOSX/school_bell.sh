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
todaySchedule="bellschedule_"$day".conf"
curl -o /Users/Shared/BellSchedule/$todaySchedule 'http://files.sscps.org/<location>/$todaySchedule'

# loop through schedule and ring if necessary
# example:  05/06/2016,8:15,8:18,8:28,9:06,9:09,9:47,9:50,9:57,10:00,10:38,10:41,11:19,11:22,12:00







