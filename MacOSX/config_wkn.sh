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

##### Global Variables #####
macAddress=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`)
wksName=wkn$macAddress
downloadScripts=0
enableBells=0
enableCaptiveHelper=0
enableCleanup=0

##### Functions #####
function rename_workstation {
   scutil --set ComputerName $wksName
   scutil --set HostName $wksName
   scutil --set LocalHostName $wksName
}

function download_scripts {
   if [ $downloadScripts -eq 1 ]; then
      if [ ! -d /usr/local/bin ]; then
         mkdir -p /usr/local/bin; fi    
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
      read -p "Hit [enter] after confirming all scripts are executable (should see 6 listed)"
    fi
}

function cfg_bells {
   if [ $enableBells -eq 1 ]; then
      plutil -replace Disabled -bool false /Library/LaunchAgents/bellschedule.plist
   elif [ $enableBells -eq 0 ]; then
      plutil -replace Disabled -bool true /Library/LaunchAgents/bellschedule.plist
   else
      echo "ERROR: enableBells is $enableBells not 0 or 1.  Aborting."
      exit; fi
 }

function cfg_captive_helper {
   if [ $enableCaptiveHelper -eq 1 ]; then
      defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean true
   elif [ $enableCaptiveHelper -eq 0 ]; then
      defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -boolean false
   else
      echo "ERROR: enableCaptiveHelper is $enableCaptiveHelper not 0 or 1.  Aborting."
      exit; fi
}

function cfg_cleanup {
   if [ $enableCleanup -eq 1 ]; then
      plutil -replace Disabled -bool false /Library/LaunchDaemons/cleanup_users.plist
   elif [ $enableCleanup -eq 0 ]; then
      plutil -replace Disabled -bool true /Library/LaunchDaemons/cleanup_users.plist
   else 
      echo "ERROR: enableCleanup is $enableCleanup not 0 or 1.  Aborting."
      exit; fi
}

function do_changes {
   rename_workstation
   download_scripts
   cfg_bells
   cfg_captive_helper
   cfg_cleanup
   read -p "Changes completed.  Do you want to reboot now?  (y/n) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "y" ]; then
      echo "Rebooting!"
      reboot
   else 
      echo "Not rebooting"; fi
}

function show_summary {
   echo "====================================================="
   echo "                  $configType"
   echo "====================================================="
   echo "Workstation name will be changed to: $wksName"
   if [ $downloadScripts -eq 1 ]; then 
      echo "Scripts will be downloaded --> REMINDER: Some scripts may need further modification!"
   else echo "Scripts will NOT be downloaded"; fi
   if [ $enableBells -eq 1 ]; then 
      echo "Bell schedule will be enabled"
   else echo "Bell schedule will NOT be enabled"; fi
   if [ $enableCaptiveHelper -eq 1 ]; then 
      echo "Captive Portal helper will be enabled"
   else echo "Captive Portal helper will NOT be enabled"; fi
   if [ $enableCleanup -eq 1 ]; then 
      echo "Cleanup users will be enabled"
   else echo "Cleanup users will NOT be enabled"; fi
   echo "====================================================="
   read -p "Are these values correct? (y/N) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "n" ] || [ "$user_input" == "" ]; then 
      echo "Values incorrect.   Aborting."
      exit
   elif [ "$user_input" == "y" ]; then 
      echo "Values correct, applying changes..."
      do_changes
   else 
      echo "ERROR:  Y or N not entered in function show_summary.  Aborting."
      exit; fi
}

function cfg_faculty {
   configType="Faculty Configuration"
   read -p "Enter workstation name (or hit [enter] to use standard format) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ ! "$user_input" == "" ]; then
      wksName=$user_input; fi
   read -p "Download scripts? (Y/n) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "y" ]; then
      downloadScripts=1; fi
   enableBells=1
   enableCleanup=0
}

function cfg_student {
   configType="Student Configuration"
   read -p "Download scripts? (Y/n) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "y" ]; then
      downloadScripts=1; fi
   enableBells=0
   enableCleanup=1
}

function cfg_prompted {
   configType="Prompted Configuration"
   read -p "Enter workstation name (or hit [enter] to use standard format) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ ! "$user_input" == "" ]; then
      wksName=$user_input; fi
   read -p "Download scripts? (Y/n) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "y" ]; then
      downloadScripts=1; fi
   read -p "Enable bell schedule? (y/N) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "y" ]; then
      enableBells=1; fi
   read -p "Enable captive portal helper?  (y/N) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "y" ]; then
      enableCaptiveHelper=1; fi
   read -p "Enable user cleanup script?  (y/N) " user_input
   user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')
   if [ "$user_input" == "y" ]; then
      enableCleanup=1; fi
}
##### End of Functions #####

# Script START

# What argument was passed to script?  (converted to lower case)
arg=$(echo "$1" | tr '[:upper:]' '[:lower:]')
if [ "$arg" == "f" ]; then
   cfg_faculty
elif [ "$arg" == "s" ]; then
   cfg_student
elif [ "$arg" == "p" ]; then
   cfg_prompted
else
   echo "Script requires an argument of (f)aculty, (s)tudent, or (p)rompted"
   exit; fi

# After setting up all variables, show summary to user which then calls do_changes
show_summary

# Script END
