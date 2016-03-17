# Run this during the Windows 10 image process to remove the built-in apps.
# copy this file to C:\temp (or wherever)
# Open a console with elevated priviledges and run "powershell"
# navigate to script and run it

# To uninstall Messaging and Skype Video apps together:
Get-AppxProvisionedPackage *messaging* | Remove-AppxProvisionedPackage

# To uninstall Sway:
Get-AppxProvisionedPackage *sway* | Remove-AppxProvisionedPackage

# To uninstall Phone and Phone Companion apps together:
Get-AppxProvisionedPackage *phone* | Remove-AppxProvisionedPackage

# To uninstall Calendar and Mail apps together:
Get-AppxProvisionedPackage *communicationsapps* | Remove-AppxProvisionedPackage

# To uninstall People:
Get-AppxProvisionedPackage *people* | Remove-AppxProvisionedPackage

# To uninstall Groove Music and Movies & TV apps together:
Get-AppxProvisionedPackage *zune* | Remove-AppxProvisionedPackage

# To uninstall Money, News, Sports and Weather apps together:
Get-AppxProvisionedPackage *bing* | Remove-AppxProvisionedPackage

# To uninstall OneNote:
Get-AppxProvisionedPackage *onenote* | Remove-AppxProvisionedPackage

# To uninstall Alarms & Clock:
Get-AppxProvisionedPackage *alarms* | Remove-AppxProvisionedPackage

# To uninstall Camera:
Get-AppxProvisionedPackage *camera* | Remove-AppxProvisionedPackage

# To uninstall Photos:
Get-AppxProvisionedPackage *photos* | Remove-AppxProvisionedPackage

# To uninstall Maps:
Get-AppxProvisionedPackage *maps* | Remove-AppxProvisionedPackage

# To uninstall Voice Recorder:
Get-AppxProvisionedPackage *soundrecorder* | Remove-AppxProvisionedPackage

# To uninstall Xbox:
Get-AppxProvisionedPackage *xbox* | Remove-AppxProvisionedPackage

# To uninstall Microsoft Solitaire Collection:
Get-AppxProvisionedPackage *solitaire* | Remove-AppxProvisionedPackage

# To uninstall Get Office:
Get-AppxProvisionedPackage *officehub* | Remove-AppxProvisionedPackage

# To uninstall Get Skype:
Get-AppxProvisionedPackage *skypeapp* | Remove-AppxProvisionedPackage

# To uninstall Get Twitter:
Get-AppxProvisionedPackage *twitter* | Remove-AppxProvisionedPackage

# To uninstall Get Started:
Get-AppxProvisionedPackage *getstarted* | Remove-AppxProvisionedPackage

# To uninstall 3D Builder:
Get-AppxProvisionedPackage *3dbuilder* | Remove-AppxProvisionedPackage
