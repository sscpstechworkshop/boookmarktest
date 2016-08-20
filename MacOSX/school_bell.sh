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
fi


dayOfWeek=`date "+%A"`
hour=`date "+%H"`
minute=`date "+%M+`

