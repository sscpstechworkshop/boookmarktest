#! /bin/bash
##########################################################################################
#
# Script Name:    config_wkn.sh
# Script Purpose: Configure standard scripts/options for Mac workstations.
# Script Usage:   One command line argument to determine how it runs.  F = defaults for
#                 faculty machine; S = defaults for student machine; P = prompt for each
#                 option.  The options and defaults are listed below.
#
#                 Change WKN Name: F = prompt, S = WKN<MAC>, P = default/empty = WKN<MAC>
#                 Download scripts: F = yes, S = yes, P = default Y
#                 Enable bell: F = yes, S = no, P = default N
#                 Ensable captive helper: F = no, S = no, P = default N
#                 Enbale cleanup users: F = yes, S = no, P = default N
#                 Hardcoded to: home_folder_lock.sh, reset_chrome.sh, untangle_logon.sh
#
# Script Notes:   Script should be installed at /usr/local/bin.
#                 Script should be run as root.
# 
########################################################################################

if [ $# -eq 0 ]; then
   mac_address=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`)
   name=WKN$mac_address
   # ENABLE cleanup_users.plist
   sed -i "" 's/false/true/g' /Library/LaunchDaemons/cleanup_users.plist
   # DISABLE school_bell.plist
   sed -i "" 's/true/false/g' /Library/LaunchAgents/school_bell.plist
else
   name=$1
   # DISABLE cleanup_users.plist
   sed -i "" 's/true/false/g' /Library/LaunchDaemons/cleanup_users.plist
   # ENABLE school_bell.plist
   sed -i "" 's/false/true/g' /Library/LaunchAgents/school_bell.plist
fi

scutil --set ComputerName $name
scutil --set HostName $name
scutil --set LocalHostName $name

tail -5 /Library/LaunchDaemons/cleanup_users.plist
echo "Check above. After RunAtLoad, true means cleanup script runs, false means it wont"
echo "Computer names changed to: $name.   If correct, reboot now"
