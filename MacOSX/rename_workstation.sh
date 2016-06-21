########################################################################################
# This script renames the three computer name variables to WKN<MAC ADDRESS>
# If an argument is supplied that will be used instead
# It should be run right after deploying an image to the machine
# Script location is /usr/local/bin
#
# NOTE: This script will also disable the cleanup_users.plist if an argument is supplied
#       on the assumption that the machine is for Staff
########################################################################################

if [ $# -eq 0 ]; then
   mac_address=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`)
   name=WKN$mac_address
   # ENABLE cleanup_users.plist
   sed -i "" 's/false/true/g' /Library/LaunchDaemons/cleanup_users.plist
else
   name=$1
   # DISABLE cleanup_users.plist
   sed -i "" 's/true/false/g' /Library/LaunchDaemons/cleanup_users.plist
fi

scutil --set ComputerName $name
scutil --set HostName $name
scutil --set LocalHostName $name

tail -5 /Library/LaunchDaemons/cleanup_users.plist
echo "Check above. After RunAtLoad, true means cleanup script runs, false means it wont"
echo "Computer names changed to: $name.   If correct, reboot now"




