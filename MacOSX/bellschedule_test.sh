##########################################################
# School bell script
#
# This script is being called every minute 
# by the /Library/LaunchAgents/bellschedule.plist file
##########################################################

# Today's date and time
year=`date "+%Y"`       # 2016
month=`date "+%m"`      # 08
dayOfMonth=`date "+%d"` # 20
day=`date "+%A"`        # Friday
hour=`date "+%H"`       # 15 (24hr format)
minute=`date "+%M"`     # 45
currentDate=$month/$dayOfMonth/$year
currentTime=$hour:$minute
confFile=/Users/Shared/BellSchedule/bellschedule.conf
mp3File=/Users/Shared/BellSchedule/bellschedule.mp3

logPath=/Users/Shared/BellSchedule/logs/
logFile=$logPath'bellschedule.log'
# Change logging to 1 to enable logging
logging=0

# create log folder
if [ ! -d $logPath ]; then
    mkdir -p $logPath
fi

function sendToLog {
    if [ $logging ]; then
        message="$currentDate $currentTime: $1"
        logger -s $message
        echo $message >> $logFile
    fi
}

sendToLog "-----> Start script"

# Read bellschedule.conf file to determine what schedule to use
if [ ! -f $confFile ]; then
   sendToLog "$confFile doesn't exist!  Run config_wkn.sh to populate it.   Aborting."
   exit
else
   remoteDir=`head -1 $confFile`
   if [ "${remoteDir}" != "middleschool" ] && [ "${remoteDir}" != "highschool" ]; then
      sendToLog "remoteDir has an invalid value of $remoteDir.  Aborting!"
      exit
   fi
fi

scheduleURL=http://files.sscps.org/bellschedule/$remoteDir/bellschedule_$day.conf
scheduleFile=/Users/Shared/BellSchedule/bellschedule_$day.conf
mp3URL=http://files.sscps.org/bellschedule/$remoteDir/bellschedule.mp3

# if schedule file doesn't exist, download it
if [ ! -f $scheduleFile ]; then
   sendToLog "$scheduleFile doesn't exist, downloading for $day..."
   curl -o $scheduleFile $scheduleURL
   chmod g+rw $scheduleFile
fi

# if uptime is 2 minutes or less, download schedule
# $uptime variable will look something like "1d, 6h, 5m"
# NOTE:   if uptime is "1d, 5h, 1m" download wont trigger, it has to be an exact match
uptime=`uptime | sed 's/^.*up *//;s/, *[0-9]* user.*$/m/;s/ day[^0-9]*/d, /;s/ \([hms]\).*m$/\1/;s/:/h, /'`
if [[ $uptime = "1m" ]] || [[ $uptime = "2m" ]]; then
   sendToLog "Uptime is 2 minutes or less so downloading schedule file for $day."
   curl -o $scheduleFile $scheduleURL
   chmod g+rw $scheduleFile
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

# populate scheduleArray from scheduleFile
sendToLog "Checking if scheduleFile exists"
if [ ! -f $scheduleFile ]; then
    sendToLog "$scheduleFile doesn't exist!   Aborting!"
    exit
else
    sendToLog "Found $scheduleFile"
    IFS=$'\r\n' GLOBIGNORE='*'
    scheduleArray=(`cat $scheduleFile`)
fi

sendToLog "Before loop that finds bell schedule"
for i in ${scheduleArray[@]}; do
    sendToLog "Line being tested is: $i"
    IFS=',' read -r -a currentTimeArray <<< "$i"
    sendToLog "currentTimeArray is: ${currentTimeArray[*]}"
    if [ "${currentTimeArray[0]}" = "default" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        sendToLog "Using default bellScheduleArray: ${bellScheduleArray[*]}"
        unset bellScheduleArray[0]
    fi
    sendToLog "Current date is: $currentDate"
    if [ "${currentTimeArray[0]}" = "$currentDate" ]; then
        bellScheduleArray=("${currentTimeArray[@]}")
        sendToLog "Changing to custom bellScheduleArray: ${bellScheduleArray[*]}"
        unset bellScheduleArray[0]
    fi
done

sendToLog "Final bellSchedule array is: ${bellScheduleArray[*]}"

# if bellSchedule has no times, exit
if [ ${#bellScheduleArray[@]} -eq 0 ]; then
     sendToLog "Schedule has no times.  Exiting."
     exit
fi

for time in ${bellScheduleArray[@]}; do
    sendToLog "Time comparison is between : time=$time currentTime=$currentTime"
    if [ "$time" = "$currentTime" ]; then
        afplay $mp3File
        exit
    fi
done
