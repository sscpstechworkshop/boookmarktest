###########################################################
# This script will initialize all user folders
# in a given OU.  Only student OUs are supported at this time 
# Valid OU arguments are:
#	level1, level2, level3, level4, levelhs
###########################################################
 
# argument must be supplied to script
Param (
    [Parameter(Mandatory=$true)]
    [string]$arg
)

Switch ($arg) {
    level1 { $OU = "OU=Level 1,OU=Students,OU=Users-Normal,OU=SSCPS,DC=ad,DC=sscps,DC=org";break}
    level2 { $OU = "OU=Level 2,OU=Students,OU=Users-Normal,OU=SSCPS,DC=ad,DC=sscps,DC=org";break}
    level3 { $OU = "OU=Level 3,OU=Students,OU=Users-Normal,OU=SSCPS,DC=ad,DC=sscps,DC=org";break}
    level4 { $OU = "OU=Level 4,OU=Students,OU=Users-Normal,OU=SSCPS,DC=ad,DC=sscps,DC=org";break}
    levelhs { $OU = "OU=Level HS,OU=Students,OU=Users-Normal,OU=SSCPS,DC=ad,DC=sscps,DC=org";break}
    default { Write-Host "Valid arguments are level1, level2, level3, level4, levelhs"; Exit}
}

Import-module ActiveDirectory

# Folders that we check for
$folders = "Documents","Movies","Music","Pictures","Downloads","Desktop","Public"

# Populate student array based on OU supplied
$student_array = Get-ADUser -SearchBase $OU -filter * | select -ExpandProperty SamAccountName

Foreach ($s in $student_array) {
    # define Home Folder path of $s
    $userObj=Get-ADUser $s -Properties homedirectory
    $path=$userObj.HomeDirectory

    # go through defined folders per student
    Foreach ($f in $folders) {
        $folder=Join-path $path $f
        if (!(Test-Path $folder) ) {
            New-item -path $path -name $f -type directory
            icacls $folder /reset
            icacls $folder /setowner $s
        }
    }
}
