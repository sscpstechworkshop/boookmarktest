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

##### Declare Functions #####

function rename_workstation {
   case "$1" in
      ( f ) echo "Enter workstation name: ";
            read workstation_name; ;;
      ( s ) mac_address=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`);
            workstation_name=wkn$mac_address; ;;
      ( * ) echo "Error in rename_workstation function, argument was not f or s"; return; ;;
   esac
   echo "Setting workstation name to: $workstation_name"
   scutil --set ComputerName $workstation_name
   scutil --set HostName $workstation_name
   scutil --set LocalHostName $workstation_name
}

function download_scripts {
   echo "Downloading scripts and pausing for 5 seconds... some scripts may need further modification."
   curl -s -L -o '/Library/LaunchAgents/bellschedule.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule.plist
   curl -s -L -o '/usr/local/bin/bellschedule.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule.sh
   curl -s -L -o '/Library/LaunchDaemons/bellschedule_perms.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule_perms.plist
   curl -s -L -o '/usr/local/bin/bellschedule_perms.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule_perms.sh
   curl -s -L -o '/Library/LaunchDaemons/cleanup_users.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/cleanup_users.plist
   curl -s -L -o '/usr/local/bin/cleanup_users.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/cleanup_users.sh
   curl -s -L -o '/Library/LaunchAgents/home_folder_lock.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/home_folder_lock.plist
   curl -s -L -o '/usr/local/bin/home_folder_lock.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/home_folder_lock.sh
   curl -s -L -o '/Library/LaunchAgents/reset_chrome.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/reset_chrome.plist
   curl -s -L -o '/usr/local/bin/reset_chrome.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/reset_chrome.sh
   curl -s -L -o '/Library/LaunchAgents/untangle_logon.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/untangle_logon.plist
   curl -s -L -o '/usr/local/bin/untangle_logon.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/untangle_logon.sh
   # Sleep for 5 seconds to make sure downloads are complete, then adjust permissions
   sleep 5
   chmod +x /usr/local/bin/bellschedule.sh;ls -l /usr/local/bin/bellschedule.sh
   chmod +x /usr/local/bin/bellschedule_perms.sh;ls -l /usr/local/bin/bellschedule_perms.sh
   chmod +x /usr/local/bin/cleanup_users.sh;ls -l /usr/local/bin/cleanup_users.sh
   chmod +x /usr/local/bin/home_folder_lock.sh;ls -l /usr/local/bin/home_folder_lock.sh
   chmod +x /usr/local/bin/reset_chrome.sh;ls -l /usr/local/bin/reset_chrome.sh
   chmod +x /usr/local/bin/untangle_logon.sh;ls -l /usr/local/bin/untangle_logon.sh
   read -p "Hit [enter] after confirming all scripts are executable"
}

function cfg_bells {
   case "$1" in
      ( 0 ) echo "Disabling bells...";
            plutil -replace Disabled -bool true /Library/LaunchAgents/bellschedule.plist; ;;
      ( 1 ) echo "Enabling bells...";
            plutil -replace Disabled -bool false /Library/LaunchAgents/bellschedule.plist; ;;
      ( * ) echo "Error in cfg_bells function... argument was not 0 or 1"; ;;
   esac     
}

function cfg_captive_helper {
   case "$1" in
      ( 0 ) echo "Disabling captive portal helper...";
            defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean false; ;;
      ( 1 ) echo "Enabling captive portal helper...";
            defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean true; ;; 
      ( * ) echo "Error in cfg_captive_helper function... argument was not 0 or 1"; ;;
    esac 
}

function cfg_cleanup {
   case "$1" in
      ( 0 ) echo "Disabling cleanup script...";
            plutil -replace Disabled -bool true /Library/LaunchDaemons/cleanup_users.plist; ;;
      ( 1 ) echo "Enabling cleanup script...";
            plutil -replace Disabled -bool false /Library/LaunchDaemons/cleanup_users.plist; ;;
      ( * ) echo "Error in cfg_cleanup function... argument was not 0 or 1"; ;;
    esac
}

function cfg_faculty {
   echo "Faculty configuration"
   rename_workstation f
   download_scripts
   cfg_bells 1
   cfg_captive_helper 0
   cfg_cleanup 0
}

function cfg_student {
   echo "Student configuration"
   rename_workstation s
   download_scripts
   cfg_bells 0
   cfg_captive_helper 0
   cfg_cleanup 1
}

function cfg_prompted {
   echo "Prompted configuration"
   echo "Rename workstation? (f)aculty (s)tudent or (n)o"
   read user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
      case "$user_input" in 
         ( f ) rename_workstation f; ;;
         ( s ) rename_workstation s; ;;
         ( n ) echo "Not renaming workstation..."; ;;
         ( * ) echo "Error in cfg_prompted function (rename workstation), user_input was not f, s, or n"; ;;
      esac
   
   echo "Download scripts? (y)es or (n)o"
   read user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
      case "$user_input" in 
         ( n ) echo "Skipping scripts download..."; ;;
         ( y ) download_scripts; ;;
         ( * ) echo "Error in cfg_prompted function (download scripts), user_input was not y or n"; ;;
      esac

   echo "Configure bells?  (e)nable or (d)isable"
   read user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
      case "$user_input" in 
         ( e ) cfg_bells 1; ;;
         ( d ) cfg_bells 0; ;;
         ( * ) echo "Error in cfg_prompted function (bells), user_input was not e or d"; ;;
      esac

   echo "Configure captive portal helper?  (e)nable or (d)isable"
   read user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
      case "$user_input" in 
         ( e ) cfg_captive_helper 1; ;;
         ( d ) cfg_captive_helper 0; ;;
         ( * ) echo "Error in cfg_prompted function (captive helper), user_input was not e or d"; ;;
      esac

   echo "Configure cleanup script?  (e)nable or (d)isable"
   read user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
      case "$user_input" in 
         ( e ) cfg_cleanup 1; ;;
         ( d ) cfg_cleanup 0; ;;
         ( * ) echo "Error in cfg_prompted function (cleanup), user_input was not e or d"; ;;
      esac      
}

##### End of Declare Functions #####

# Script START

# What argument was passed to script?  (converted to lower case)
arg=$(echo "$1" | tr '[:upper:]' '[:lower:]')
case "$arg" in
   ( f ) cfg_faculty; ;;
   ( s ) cfg_student; ;;
   ( p ) cfg_prompted; ;;
   ( * ) echo "This script accepts the following options:  (f)aculty, (s)tudent, (p)rompted"; exit; ;;
esac

echo "Do you want to reboot now? (y)es or (n)o"
read user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
      case "$user_input" in 
         ( y ) echo "Rebooting..."; reboot; ;;
         ( n ) echo "Not rebooting..."; ;;
         ( * ) echo "Error asking for reboot, user_input was not y or n"; ;;
      esac    
      
# Script END




