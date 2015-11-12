# This script will generate a list of user and OU
# sort the result and pass users through move_user_ou script

Import-Module ActiveDirectory

#$list=Get-Content c:\TechTools\all_studentuserfiles.txt

Foreach ($s in $list)
{
   $sAD=Get-ADUser $s
   $ou=$sAD.DistinguishedName -creplace "^[^,]*,",""
   $logfile="c:\TechTools\"+$ou+".txt"
   Add-Content -path $logfile -value $s
}
