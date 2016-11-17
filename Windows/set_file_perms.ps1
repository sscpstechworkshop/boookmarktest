# This script accepts 3 arguments:
#    required argument: fileserver (GREG, ROWLEY, FREGLEY, RODRICK)
#    required argument: population (student, facstaff)
#    optional argument: user  (e.g. jmcsheffrey, sstaff, joe_student)
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

# TEST variables - Set up folder variables
if ( $fileserver -eq "rowley" ) {
   $fac_user_folder = "\\ROWLEY\e$\Storage\Test\FacStaffUserFiles\"
   $fac_other_folder = "\\ROWLEY\e$\Storage\Test\FacStaffOtherFiles\"
   $stu_user_folder = "\\ROWLEY\e$\Storage\Test\StudentUserFiles\"
   $stu_other_folder = "\\ROWLEY\e$\Storage\Test\StudentOtherFiles\"
}
else {
   $fac_user_folder = "\\" + $fileserver + "\c$\Storage\Test\FacStaffUserFiles\"
   $fac_other_folder = "\\" + $fileserver + "\c$\Storage\Test\FacStaffOtherFiles\"
   $stu_user_folder = "\\" + $fileserver + "\c$\Storage\Test\StudentUserFiles\"
   $stu_other_folder = "\\" + $fileserver + "\c$\Storage\Test\StudentOtherFiles\"
}

# Was user argument supplied?
if ( $user ) {
   if ( $population -eq "facstaff" ) {
      process_permissions($fac_user_folder$user)
      process_permissions($fac_other_folder$user)
   }
   if ( $population -eq "student" ) {
      process_permissions($stu_user_folder$user)
      process_permissions($stu_other_folder$user)
   }
   Exit
}

# user not supplied, fix all folders for given fileserver
if ( $population -eq "facstaff" ) {
   $user_folder_array = @(Get-ChildItem -Path $fac_user_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   $other_folder_array = @(Get-ChildItem -Path $fac_other_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   
   Foreach ($f in $user_folder_path) {
      process_permissions($f)
   }
   Foreach ($f in $other_folder_path) {   
      process_permissions($f)
   }
}

if ( $population -eq "student" ) {
   $user_folder_array = @(Get-ChildItem -Path $stu_user_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   $other_folder_array = @(Get-ChildItem -Path $stu_other_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   
   Foreach ($f in $user_folder_path) {
      process_permissions($f)
   }
   Foreach ($f in $other_folder_path) {   
      process_permissions($f)
   }
}

# These are the permissions each folder will get
# (OI) Object Inheritence (CI) Container Inheritence F Full control
$perms = "(OI)(CI)F"

# Function to set up permissions
# Accepts a UNC (e.g. \\GREG\c$\FacStaffUserFiles\jmcsheffrey)
function process_permissions($f) {
   $u = $f | Split-Path -leaf
   takeown /f $f /r /d y
   icacls $f /grant $u:$perms /t
   icacls $f /setowner $u /t
}
