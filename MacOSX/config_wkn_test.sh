#! /bin/bash
##########################################################################################
#
# Script Name:    config_wkn.sh
# Script Purpose: Configure standard scripts/options for Mac workstations.
# Script Usage:   One command line argument to determine how it runs.  F = defaults for
#                 faculty machine; S = defaults for student machine; P = prompt for each
#                 option.  The options and defaults are listed below.
#
#                 Change WKN Name: F = prompt, S = WKN<MAC>, P = promt
#                 Download scripts: F = yes, S = yes, P = default Y
#                 Enable bell: F = yes, S = no, P = default N
#                 Enable captive helper: F = no, S = no, P = default N
#                 Enable cleanup users: F = no, S = yes, P = default N
#                 Hardcoded to: home_folder_lock.sh, reset_chrome.sh, untangle_logon.sh
#
# Script Notes:   Workstation naming defaults to WKN<MAC> if prompt is empty.
#                 Script should be installed at /usr/local/bin.
#                 Script should be run as root.
# 
########################################################################################

if [ $# -eq 0 ]; then
   mac_address=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`)
   name=WKN$mac_address
   # ENABLE cleanup_users.plist
   sed -i "" 's/false/true/g' /Library/LaunchDaemons/cleanup_users.plist
   # DISABLE bellschedule.plist
   sed -i "" 's/true/false/g' /Library/LaunchAgents/bellschedule.plist
else
   name=$1
   # DISABLE cleanup_users.plist
   sed -i "" 's/true/false/g' /Library/LaunchDaemons/cleanup_users.plist
   # ENABLE bellschedule.plist
   sed -i "" 's/false/true/g' /Library/LaunchAgents/bellschedule.plist
fi

scutil --set ComputerName $name
scutil --set HostName $name
scutil --set LocalHostName $name

tail -5 /Library/LaunchDaemons/cleanup_users.plist
echo "Check above. After RunAtLoad, true means cleanup script runs, false means it wont"
echo "Computer names changed to: $name.   If correct, reboot now"
