# This script renames the three computer name variables to WKN<MAC ADDRESS>
# It should be run right after deploying an image to the machine
# Script location should be /usr/local/bin

name=(`ifconfig en0 | awk '/ether/{print $2}' | sed -e 's/://g'`)
scutil --set ComputerName WKN$name
scutil --set HostName WKN$name
scutil --set LocalHostName WKN$name
reboot

