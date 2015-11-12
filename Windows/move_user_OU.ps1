# This script is intended to move a user OU to a specific OU
# and set the matching home drive and folder

Import-Module ActiveDirectory

#uncomment this line when you've populated a text file
#$list=Get-Content C:\TechTools\scripts\move_my_ou.txt

# NOTE: You will have to modify this loop before running!
Foreach ($s in $list)
{
   Get-ADUser $s | Move-ADObject -TargetPath "OU=Level HS (GREG),OU=Students,OU=Users-Normal,OU=SSCPS,DC=ad,DC=sscps,DC=org"
   Set-ADUser $s -HomeDrive "H:" -HomeDirectory \\GREG\StudentUserFiles$\$s
}
