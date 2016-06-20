########################################################################################
# This script renames the three computer name variables to WKN<MAC ADDRESS>
# If an argument is supplied that will be used instead
# It should be run right after deploying an image to the machine
# Script location is /usr/local/bin
#
# NOTE: This script will also disable the cleanup_users.plist if an argument is supplied
#       on the assumption that the machine is for Staff
########################################################################################

name=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`)
scutil --set ComputerName WKN$name
scutil --set HostName WKN$name
scutil --set LocalHostName WKN$name
reboot

