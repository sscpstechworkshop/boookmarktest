########################################################################################################
# Purpose:  Modify user/other folders with proper ACLs.   Will also create user folders where needed.
#
# This script accepts 3 arguments:
#    NOTE:  If required arguments are left out, script will prompt you for them
#    required argument: fileserver (GREG, ROWLEY, FREGLEY, RODRICK)
#    required argument: population (student, facstaff)
#    optional argument: user  (e.g. jmcsheffrey, sstaff, joe_student)
#    if no user, script will act on all folders (User & Other) of given fileserver and population
#
# Usage examples (run as administrator or script will add yourself to ACLs):
#   The following will set permissions for joe_student on GREG
#      .\set_file_perms.ps1 -fileserver greg -population student -user joe_student
#   To achieve the same result you can also do (script will prompt for required arguments):
#      .\set_file_perms.ps1 -user joe_student
#   Fix permissions for all students on GREG:
#      .\set_file_perms.ps1 -fileserver greg -population student
#   Fix permissions for Sam Staff
#      .\set_file_perms.ps1 -fileserver greg -population facstaff -user sstaff
#
# REQUIRES:  subinacl tool must be installed on server you run this from
#            https://www.microsoft.com/en-us/download/details.aspx?id=23510
#            Then add the following to the server's PATH:
#            C:\Program Files (x86)\Windows Resource Kits\Tools\
########################################################################################################

# arguments
param( 
   [Parameter(Mandatory=$true)]
   [string]$fileserver,
   [Parameter(Mandatory=$true)]
   [string]$population,
   [string]$user
)

<#
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
#>

# PRODUCTION variables - Set up folder variables
if ( $fileserver -eq "rowley" ) {
   $fac_user_folder = "\\ROWLEY\e$\Storage\FacStaffUserFiles\"
   $fac_other_folder = "\\ROWLEY\e$\Storage\FacStaffOtherFiles\"
   $stu_user_folder = "\\ROWLEY\e$\Storage\StudentUserFiles\"
   $stu_other_folder = "\\ROWLEY\e$\Storage\StudentOtherFiles\"
}
else {
   $fac_user_folder = "\\" + $fileserver + "\c$\Storage\FacStaffUserFiles\"
   $fac_other_folder = "\\" + $fileserver + "\c$\Storage\FacStaffOtherFiles\"
   $stu_user_folder = "\\" + $fileserver + "\c$\Storage\StudentUserFiles\"
   $stu_other_folder = "\\" + $fileserver + "\c$\Storage\StudentOtherFiles\"
}

# Fuction to create user folders if needed
# Accepts UNC (e.g. \\GREG\c$\Storage\FacStaffUserFiles\jmcsheffrey\)
function check_user_folders($f) {
   $folders = "Documents","Downloads","Desktop","Movies","Music","Public","Pictures"
   Foreach ($folder in $folders) {
      if( ! ( Test-Path $f\$folder) ) {
         New-Item -path $f -name $folder -type directory
      }
   }
}

# Function to set up permissions
# Accepts a UNC (e.g. \\GREG\c$\Storage\FacStaffUserFiles\jmcsheffrey\)
function process_permissions($f) {
   $u = $f | Split-Path -leaf
   $grant_perms = $u + ":(OI)(CI)F"
   icacls $f /reset /t
   # Do not use /t with /grant - subfolders are handled by inheritence
   icacls $f /grant "$grant_perms"
   # Set the owner of the parent user folder (e.g. jmcsheffrey)
   # subinacl /subdirectories does NOT modify the root folder of path given! So, we have to do it manually
   subinacl /file $f /setowner=$u
   # Now set the owner for all the users content
   subinacl /subdirectories $f /setowner=$u
}

# Was user argument supplied?
if ( $user ) {
   if ( $population -eq "facstaff" ) {
      $user_path = $fac_user_folder + $user + "\" 
      $other_path = $fac_other_folder + $user + "\"
   }
   if ( $population -eq "student" ) {
      $user_path = $stu_user_folder + $user + "\"
      $other_path = $stu_other_folder + $user + "\"
   }
   check_user_folders($user_path)
   process_permissions($user_path)
   process_permissions($other_path)
   Exit
}

# user not supplied, fix all folders for given fileserver
# subinacl /subdirectories type fails if trailing backslash is missing
# so it has been added in when array is built, or specified user above
if ( $population -eq "facstaff" ) {
   $user_folder_array = @(Get-ChildItem -Path $fac_user_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
   $other_folder_array = @(Get-ChildItem -Path $fac_other_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
}

if ( $population -eq "student" ) {
   $user_folder_array = @(Get-ChildItem -Path $stu_user_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
   $other_folder_array = @(Get-ChildItem -Path $stu_other_folder | ?{ $_.PSIsContainer } | Foreach-Object {$_.FullName+"\"})
}
  
Foreach ($f in $user_folder_array) {
   check_user_folders($f)
   process_permissions($f)
}
Foreach ($f in $other_folder_array) {   
   process_permissions($f)
}
