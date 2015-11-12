# This script will setup the ACL for users

Import-Module ActiveDirectory

#Uncomment the following line after building your text file with "dir /b" 
#$list = Get-Content c:\TechTools\all_facstaff_GREG.txt

$of="C:\Storage\FacStaffOtherFiles\"
$uf="C:\Storage\FacStaffUserFiles\"
$pf="C:\Storage\FacStaffProfiles\"

Foreach ($s in $list)
{
   $sV2=$s+".V2"
   $sGrant=$s+":(OI)(CI)F"

   takeown /f $of$s /r /d y
   takeown /f $uf$s /r /d y
   takeown /f $pf$sV2 /r /d y

   icacls $of$s /reset /t
   icacls $of$s /setowner $s /t
   icacls $of$s /grant $sGrant

   icacls $uf$s /reset /t
   icacls $uf$s /setowner $s /t
   icacls $uf$s /grant $sGrant

   icacls $pf$sV2 /reset /t
   icacls $pf$sV2 /setowner $s /t
   icacls $pf$sV2 /grant $sGrant
}
