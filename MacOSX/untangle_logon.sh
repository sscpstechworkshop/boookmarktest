#!/usr/bin/env bash
# Bash skips errors and resumes by default
# This script is based on the ad_login.vb script provided by untangle.com.

#for testing/debugging today's date and time
#year=`date "+%Y"`       # 2016
#month=`date "+%m"`      # 08
#dayOfMonth=`date "+%d"` # 20
#hour=`date "+%H"`       # 15 (24hr format)
#minute=`date "+%M"`     # 45
#date=$month/$dayOfMonth/$year
#time=$hour:$minute

#if [ ! -d /Users/$USER/logs ]; then
#   mkdir -p /Users/$USER/logs    
#fi

#logPath=/Users/$USER/logs/
#logFile=$logPath'untangle_logon.log'

function sendToLog {
   message="$date $time: $1"
   logger -s $message
   echo $message >> $logFile
}

function getGateway {
   gateway=(`netstat -rn | grep "default" | awk '{print $2}'`)
   SERVERNAME="${gateway[0]}" 
}

getGateway

# Check for valid gateway, wifi sometimes needs a moment
# loop every 5 seconds for 30 seconds or until valid gateway found
COUNTER=0
   while [ $COUNTER -lt 5 ]; do
#      sendToLog "In while loop, counter:$COUNTER server:$SERVERNAME"
      if [ $SERVERNAME ]; then
         break;
      else
         sleep 5
         getGateway
         let COUNTER=COUNTER+1
#         sendToLog "After sleep, counter:$COUNTER server:$SERVERNAME"
      fi
done

# log any previous user to system out of the Captive Portal
curl --location http://"${SERVERNAME}"/capture/logout

strUser=$USER
strDomain=AD
strHostname=$(hostname -s)

# This should "overwrite" any active Directory Connector credentials
URLCOMMAND="http://"${SERVERNAME}"/userapi/registration?username="${strUser}"&domain="${strDomain}"&hostname="${strHostname}"&action=login&secretKey=<CHANGEME>"
curl -f -s -m 10 $URLCOMMAND

#sendToLog "Script executed. Gateway: $SERVERNAME"
#sendToLog $URLCOMMAND
