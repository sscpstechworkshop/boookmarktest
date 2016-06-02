###############################################################################
# This powershell script will uninstall all provisioned apps that are
# currently installed for any user, as well as any future user that logs in
# Open console with elevated priviledges and run "powershell"
# NOTE:  In order to run a powershell script you will have to first run:
#        Set-ExecutionPolicy Unrestricted
###############################################################################

#Uninstall 3D Builder:
Get-AppxPackage *3dbuilder* -allusers | Remove-AppxPackage

#Uninstall Alarms and Clock:
Get-AppxPackage *windowsalarms* -allusers | Remove-AppxPackage

#Uninstall Calculator:
Get-AppxPackage *windowscalculator* -allusers | Remove-AppxPackage

#Uninstall Calendar and Mail:
Get-AppxPackage *windowscommunicationsapps* -allusers | Remove-AppxPackage

#Uninstall Camera:
Get-AppxPackage *windowscamera* -allusers | Remove-AppxPackage

#Uninstall Get Office:
Get-AppxPackage *officehub* -allusers | Remove-AppxPackage

#Uninstall Get Skype:
Get-AppxPackage *skypeapp* -allusers | Remove-AppxPackage

#Uninstall Get Started:
Get-AppxPackage *getstarted* -allusers | Remove-AppxPackage

#Uninstall Groove Music:
Get-AppxPackage *zunemusic* -allusers | Remove-AppxPackage

#Uninstall Maps:
Get-AppxPackage *windowsmaps* -allusers | Remove-AppxPackage

#Uninstall Microsoft Solitaire Collection:
Get-AppxPackage *solitairecollection* -allusers | Remove-AppxPackage

#Uninstall Money:
Get-AppxPackage *bingfinance* -allusers | Remove-AppxPackage

#Uninstall Movies & TV:
Get-AppxPackage *zunevideo* -allusers | Remove-AppxPackage

#Uninstall News:
Get-AppxPackage *bingnews* -allusers | Remove-AppxPackage

#Uninstall OneNote:
Get-AppxPackage *onenote* -allusers | Remove-AppxPackage

#Uninstall People:
Get-AppxPackage *people* -allusers | Remove-AppxPackage

#Uninstall Phone Companion, Phone:
Get-AppxPackage *phone* -allusers | Remove-AppxPackage

#Uninstall Photos:
Get-AppxPackage *photos* -allusers | Remove-AppxPackage

#Uninstall Store:
Get-AppxPackage *windowsstore* -allusers | Remove-AppxPackage

#Uninstall Sports:
Get-AppxPackage *bingsports* -allusers | Remove-AppxPackage

#Uninstall Voice Recorder:
Get-AppxPackage *soundrecorder* -allusers | Remove-AppxPackage

#Uninstall Weather:
Get-AppxPackage *bingweather* -allusers | Remove-AppxPackage

#Uninstall Xbox:
Get-AppxPackage *xboxapp* -allusers | Remove-AppxPackage

#Uninstall Candy Crush
Get-AppxPackage *candy* -allusers | Remove-AppxPackage

#Uninstall Messaging
Get-AppxPackage *messaging* -allusers | Remove-AppxPackage

#Uninstall Sway
Get-AppxPackage *sway* -allusers | Remove-AppxPackage

#Uninstall Twitter
Get-AppxPackage *twitter* -allusers | Remove-AppxPackage

# The above removes existing installs on local users
# The following removes the apps from all future users

#Remove all provisioned apps
Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online
