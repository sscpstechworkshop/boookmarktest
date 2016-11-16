# This script accepts 3 arguments:
#    required argument: fileserver (GREG, ROWLEY, FREGLEY, RODRICK)
#    required argument: population (student, facstaff)
#    optional argument: user  (jmcsheffrey, sstaff, joe_student)
#    if no user, script will perform on all folders (User & Other) of given fileserver

# arguments
param( 
   [Parameter(Mandatory=$true)][string]$fileserver,
   [Parameter(Mandatory=$true)][string]$population,
   [string]$user
)

# Check for mandatory arguments
if ( !($fileserver) -Or !($population) ) {
   Write-Host "Must supply -fileserver and -population arguments"
   Exit
}

# Set up folder variables
$fac_user_folder = "\\" + $fileserver + "\FacStaffUserFiles$\"
$fac_other_folder = "\\" + $fileserver + "\FacStaffOtherFiles$\"
$stu_user_folder = "\\" + $fileserver + "\StudentUserFiles$\"
$stu_other_folder = "\\" + $fileserver + "\StudentOtherFiles$\"

# Was user argument supplied?
if ( $user ) {
   if ( $population -eq "facstaff" ) {
      fix-acl($fac_user_folder$user $user)
      fix-acl($fac_other_folder$user $user)
   }
   if ( $population -eq "student" ) {
      fix-acl($stu_user_folder$user $user)
      fix-acl($stu_other_folder$user $user)
   }
   Exit
}

# user not supplied, fix all folders for given fileserver
# check population and build array of folders to loop through
if ( $population -eq "facstaff" ) {
   $user_folder_array = @(Get-ChildItem -Path $fac_user_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   $other_folder_array = @(Get-ChildItem -Path $fac_other_folder | ?{ $_.PSIsContainer } | Select-Object FullName)

   Foreach ($f in $user_folder_array) {
      # each element in array will look like \\GREG\FacStaffUserFiles$\jmcsheffrey
      # need to get user name from last part of each element in array
      $u = $f | Split-Path -leaf
      fix-acl($f $u)
   }
   Foreach ($f in $other_folder_array) {
      $u = $f | Split-Path -leaf
      fix-acl($f $u)
   }
}

if ( $population -eq "student" ) {
   $user_folder_array = @(Get-ChildItem -Path $stu_user_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   $other_folder_array = @(Get-ChildItem -Path $stu_other_folder | ?{ $_.PSIsContainer } | Select-Object FullName)

   Foreach ($f in $user_folder_array) {
      # each element in array will look like \\GREG\FacStaffUserFiles$\jmcsheffrey
      # need to get user name from last part of each element in array
      $u = $f | Split-Path -leaf
      fix-acl($f $u)
   }
   Foreach ($f in $other_folder_array) {
      $u = $f | Split-Path -leaf
      fix-acl($f $u)
   }
}

# function that does the heavy lifting
# folder and user are passed to it
function fix-acl($f $u) {
   $perms = "(OI)(CI)F"
   takeown /f $f /r /d y
   icacls $f /grant $u:$perms /t
   icacls $f /setowner $u /t
}

