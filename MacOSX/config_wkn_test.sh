#! /bin/bash
##########################################################################################
#
# Script Name:    config_wkn.sh
# Script Purpose: Configure standard scripts/options for Mac workstations.
# Script Usage:   One command line argument to determine how it runs.  F = defaults for
#                 faculty machine; S = defaults for student machine; P = prompt for each
#                 option.  The options and defaults are listed below.
#
#                 Change WKN Name: F = prompt, S = WKN<MAC>, P = prompt
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

### Variables

# boolDisableBell
# boolDisableCaptiveHelper
# boolDownloadScripts

### End of Variables

### Functions
function rename_workstation {
   echo "Setting workstation name to: $1"
   scutil --set ComputerName $1
   scutil --set HostName $1
   scutil --set LocalHostName $1
}

function download_scripts {
   echo "Downloading scripts... don't forget to modify UT script." 
   curl -L -o '/Library/LaunchAgents/bellschedule.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule.plist
   curl -L -o '/usr/local/bin/bellschedule.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule.sh
   chmod +X /usr/local/bin/bellschedule.sh

   curl -L -o '/Library/LaunchDaemons/bellschedule_perms.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule_perms.plist
   curl -L -o '/usr/local/bin/bellschedule_perms.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule_perms.sh
   chmod +X /usr/local/bin/bellschedule_perms.sh

   curl -L -o '/Library/LaunchDaemons/cleanup_users.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/cleanup_users.plist
   curl -L -o '/usr/local/bin/cleanup_users.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/cleanup_users.sh
   chmod +X /usr/local/bin/cleanup_users.sh

   #curl -L -o '/usr/local/bin/config_wkn.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/config_wkn.sh
   #chmod +X /usr/local/bin/config_wkn.sh

   curl -L -o '/Library/LaunchAgents/home_folder_lock.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/home_folder_lock.plist
   curl -L -o '/usr/local/bin/home_folder_lock.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/home_folder_lock.sh
   chmod +X /usr/local/bin/home_folder_lock.sh

   curl -L -o '/Library/LaunchAgents/reset_chrome.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/reset_chrome.plist
   curl -L -o '/usr/local/bin/reset_chrome.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/reset_chrome.sh
   chmod +X /usr/local/bin/reset_chrome.sh

   curl -L -o '/Library/LaunchAgents/untangle_logon.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/untangle_logon.plist
   curl -L -o '/usr/local/bin/untangle_logon.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/untangle_logon.sh
   chmod +X /usr/local/bin/untangle_logon.sh
}

function cfg_bells {
   case "$1" in
      ( 0 ) echo "Disabling bells...";
            sed -i "" 's/true/false/g' /Library/LaunchAgents/bellschedule.plist; ;;
      ( 1 ) echo "Enabling bells...";
            sed -i "" 's/false/true/g' /Library/LaunchAgents/bellschedule.plist; ;;
      ( * ) echo "Error configuring bells... value not 0 or 1"; ;;
   esac     
}

function cfg_captive_helper {
   case "$1" in
      ( 0 ) echo "Disabling captive portal helper...";
            defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean false; ;;
      ( 1 ) echo "Enabling captive portal helper...";
            defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean true; ;; 
      ( * ) echo "Error configuring captive portal helper... value not 0 or 1"; ;;
    esac 
}

function cfg_cleanup {
   case "$1" in
      ( 0 ) echo "Disabling cleanup script...";
            sed -i "" 's/true/false/g' /Library/LaunchDaemons/cleanup_users.plist; ;;
      ( 1 ) echo "Enabling cleanup script...";
            sed -i "" 's/false/true/g' /Library/LaunchDaemons/cleanup_users.plist; ;;
      ( * ) echo "Error configuring cleanup script... value not 0 or 1"; ;;
    esac
}

function cfg_faculty {
   echo "Faculty configuration"
   echo "Enter workstation name: "
   read workstation_name
   rename_workstation $workstation_name
   download_scripts
   cfg_bells 1
   cfg_captive_helper 0
   cfg_cleanup 0   
}

function cfg_student {
   echo "Student configuration"
   mac_address=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`)
   workstation_name=WKN$mac_address
   rename_workstation $workstation_name
   download_scripts
   cfg_bells 0
   cfg_captive_helper 0
   cfg_cleanup 1
}

# TODO: Prompted configuration 
#function cfg_prompted {
#   echo "Rename workstation?"
#   read user_input
#   rename_prompt=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
#   case "$rename_prompt" in
#      ( y ) echo "Rename for (F)aculty or (S)tudent?";
#            read user_input
#            rename_model=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
#            case "$rename_model" in
#               ( f ) 
#}


### End of Functions


# What argument did user use?  (converted to lower case)
arg=$(echo "$#" | tr '[:upper:]' '[:lower:]')
case "$arg" in
   ( f ) echo "F - $arg"; cfg_faculty; ;;
   ( s ) echo "S - $arg"; cfg_student; ;;
   ( p ) echo "P - $arg"; cfg_prompted; ;;
   ( * ) echo "This script accepts the following options:  (F)aculty, (S)tudent, (P)rompted"; ;;
esac




