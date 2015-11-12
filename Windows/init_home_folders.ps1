###########################################################
# This script checks for the existance of the folders
# defined in the $folders array on the user supplied
# This was written so that our home_folder_lock.sh script
# on Macs will be able to mount these folders
###########################################################
 
# User name must be supplied to script
Param (
    [Parameter(Mandatory=$true)]
    [string]$user 
)

Import-module ActiveDirectory

# define Home Folder path of user
# e.g. $path should look like \\ROWLEY\FacStaffUserFiles$\jmcsheffrey
$userObj=Get-ADUser $user -Properties homedirectory
$path=$userObj.HomeDirectory

# Folders that we check for
$folders = "Documents","Movies","Music","Pictures","Downloads","Desktop","Public"

Foreach ($f in $folders) {
    $folder=Join-path $path $f
    if (!(Test-Path $folder) ) {
        New-item -path $path -name $f -type directory
        icacls $folder /reset
        icacls $folder /setowner $user
    }
}
