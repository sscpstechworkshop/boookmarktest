# This script accepts 3 arguments:
#    required argument: fileserver (GREG, ROWLEY, FREGLEY, RODRICK)
#    required argument: population (student, facstaff)
#    optional argument: user  (e.g. jmcsheffrey, sstaff, joe_student)
#    if no user, script will perform on all folders (User & Other) of given fileserver

# arguments
param( 
   [Parameter(Mandatory=$true)]
   [string]$fileserver,
   [Parameter(Mandatory=$true)]
   [string]$population,
   [string]$user
)

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

# Fuction to create user folders if needed
# Accepts a UNC (e.g. \\GREG\c$\Storage\FacStaffUserFiles\jmcsheffrey)
function check_user_folders($f) {
   $folders = "Documents","Downloads","Desktop","Movies","Music","Public","Pictures"
   Foreach ($folder in $folders) {
      if( ! ( Test-Path $f\$folder) ) {
         New-Item -path $f -name $folder -type directory
      }
   }
}


# Function to set up permissions
function process_permissions($f) {
   $u = $f | Split-Path -leaf
   takeown /f $f /r /d y
   $grant_perms = $u + ":(OI)(CI)F"
   # /grant:r any previously granted explicit permissions are replaced
   # Do not use /t with /grant - subfolders are handled by inheritence
   icacls $f /grant:r $grant_perms
   icacls $f /setowner $u /t
}

# Was user argument supplied?
if ( $user ) {
   if ( $population -eq "facstaff" ) {
      $user_path = $fac_user_folder + $user
      $other_path = $fac_other_folder + $user
      check_user_folders($user_path)
      process_permissions($user_path)
      process_permissions($other_path)
   }
   if ( $population -eq "student" ) {
      $user_path = $stu_user_folder + $user
      $other_path = $stu_other_folder + $user
      check_user_folders($user_path)
      process_permissions($user_path)
      process_permissions($other_path)
   }
   Exit
}

# user not supplied, fix all folders for given fileserver
if ( $population -eq "facstaff" ) {
   $user_folder_array = @(Get-ChildItem -Path $fac_user_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   $other_folder_array = @(Get-ChildItem -Path $fac_other_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   
   Foreach ($f in $user_folder_array) {
      check_user_folders($f)
      process_permissions($f)
   }
   Foreach ($f in $other_folder_array) {   
      process_permissions($f)
   }
}

if ( $population -eq "student" ) {
   $user_folder_array = @(Get-ChildItem -Path $stu_user_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   $other_folder_array = @(Get-ChildItem -Path $stu_other_folder | ?{ $_.PSIsContainer } | Select-Object FullName)
   
   Foreach ($f in $user_folder_array) {
      check_user_folders($f)
      process_permissions($f)
   }
   Foreach ($f in $other_folder_array) {   
      process_permissions($f)
   }
}

