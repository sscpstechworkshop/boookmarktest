#################################################################
# Script downloader
#
# This script will download all macOS scripts from Github and
# place them in the proper folder and give execution rights
# to the .sh files.   Should be run as root.
#################################################################

curl -L -o '/Library/LaunchAgents/bellschedule.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule.plist
curl -L -o '/usr/local/bin/bellschedule.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule.sh
chmod +X /usr/local/bin/bellschedule.sh

curl -L -o '/Library/LaunchDaemons/bellschedule_perms.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule_perms.plist
curl -L -o '/usr/local/bin/bellschedule_perms.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/bellschedule_perms.sh
chmod +X /usr/local/bin/bellschedule_perms.sh

curl -L -o '/Library/LaunchDaemons/cleanup_users.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/cleanup_users.plist
curl -L -o '/usr/local/bin/cleanup_users.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/cleanup_users.sh
chmod +X /usr/local/bin/cleanup_users.sh

curl -L -o '/usr/local/bin/config_wkn.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/config_wkn.sh
chmod +X /usr/local/bin/config_wkn.sh

curl -L -o '/Library/LaunchAgents/home_folder_lock.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/home_folder_lock.plist
curl -L -o '/usr/local/bin/home_folder_lock.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/home_folder_lock.sh
chmod +X /usr/local/bin/home_folder_lock.sh

curl -L -o '/Library/LaunchAgents/reset_chrome.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/reset_chrome.plist
curl -L -o '/usr/local/bin/reset_chrome.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/reset_chrome.sh
chmod +X /usr/local/bin/reset_chrome.sh

curl -L -o '/Library/LaunchAgents/untangle_logon.plist' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/untangle_logon.plist
curl -L -o '/usr/local/bin/untangle_logon.sh' https://raw.githubusercontent.com/SSCPS/TechTools/master/MacOSX/untangle_logon.sh
chmod +X /usr/local/bin/untangle_logon.sh
# DON'T FORGET TO MODIFY THE untangle_logon.sh SCRIPT AFTER DOWNLOADING

