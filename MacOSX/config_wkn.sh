########################################################################################
# If an argument is supplied (faculty machine):
#    - rename workstation to argument supplied
#    - disable cleanup_users.plist
#    - enable bellschedule.plist
# If no argument (student machine):
#    - rename workstation to WKN<MAC Address>
#    - enable cleanup_users.plist
#    - disable bellschedule.plist
#
# script should be installed at /usr/local/bin
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



