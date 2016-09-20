#!/usr/bin/env bash
# Bash skips errors and resumes by default
# This script is based on the ad_login.vb script provided by untangle.com.

# Time in seconds to sleep between requests
SLEEP_PERIOD=300

# Lets define the protocol to be used.
URL_PREFIX="http"

gateway=(`netstat -rn | grep "default" | awk '{print $2}'`)
SERVERNAME="${gateway[0]}"

# log any previous user to system out of the Captive Portal (not Directory Connector)
curl --location http://"${SERVERNAME}"/capture/logout

# set strUSER to current user
strUser=$USER
strDomain=AD
strHostname=$(hostname -s)

# This should "overwrite" any active Directory Connector credentials
# Execute script until logout
while true; do
     gateway=(`netstat -rn | grep "default" | awk '{print $2}'`)
     SERVERNAME="${gateway[0]}"

     URLCOMMAND=${URL_PREFIX}"://"${SERVERNAME}"/userapi/registration?username="${strUser}"&domain="${strDomain}"&hostname="${strHostname}"&action=login""&secretKey=<changeme>"

     # Take out the comments below for testing the urlcommand
     # curl arguments: -f fails silently, -s silent mode with no progress status, -m maximum execution time allowed
     curl -f -s -m 10 $URLCOMMAND
     sleep $SLEEP_PERIOD
done
