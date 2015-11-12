#################################################################################
#
# PURPOSE: When using roaming profiles, there are some directories that should
#          be excluded.  If directories have been added to a Group Policy after
#          roaming profiles have been is use, they need to be cleared.  
#
#          An added feature has been to remove a single file.  This is done
#          for when a directory should be used for roaming, but file(s) may get
#          too large.  For this purpose, the script could be run routinely.
#
#          NOTE:  This script does not remove directories, only contents.
#          NOTE:  Wildcards can NOT be used at this point in time.  
#  
# USAGE:   This script is designed to be run without parameters.  Change the
#          variables at the beginning to define appropriate parameters. 
#
#          Logging will automatically create subfolder that is the name of the 
#          script and date & time stamped file with the name of the script in 
#          location found in the PARAMETERS section.  
#          E.g. \cleanup_files\cleanup_files-20130125235901.log
#
#          Running via Windows Task Scheduler:
#            powershell -file "C:\Tech_Stuff\Scripts\cleanup_profiles.ps1"
#
# CONFIG:  Based on above comments, populate 2 arrays with appropriate values.
#          Wildcards can NOT be used at this point in time.  
#
# AUTHOR:  Ralph deGennaro
# HISTORY: 2013-03-15 - Ralph deGennaro - First copied from another script
#          2013-03-16 - Ralph deGennaro - setup variables 
#          2013-04-17 - Ralph deGennaro - various random cleanups
#          2013-05-10 - Ralph deGennaro - basic structure & workflow of script
#                       also added removal commands & basic testing
#################################################################################

#
# Initial setup, DO NOT CHANGE THESE VALUES
#
$varFolderArray = @()
$varFileArray = @()

#
# PARAMETERS
#
$varLogFilePath = 'C:\TechTools\Logs'
$varRootFolder = 'C:\Storage\Pofiles'
# add values to arrays, copy & uncomment as needed
#$varFolderArray += ''
#$varFileArray += ''
# start file array for list of files to remove
$varFileArray += '\AppData\Local\Microsoft\OneNote\14.0\OneNoteOfflineCache.onecache'
$varFileArray += '\AppData\LocalLow\Google\GoogleEarth\dbCache.dat'
$varFileArray += '\AppData\LocalLow\Google\GoogleEarthPlugin\dbCache.dat'
$varFileArray += '\AppData\Local\Microsoft\Windows\WindowsUpdate.log'
# below are wild card files to be tested later
#$varFileArray += '\AppData\Local\Google\Chrome\User Data\Default\prf*.tmp'
#$varFileArray += '\Chrome\User Data\Default\prf*.tmp'
# start Folder/Directory array for list of folders to empty & leave folder
$varFolderArray += '\AppData\Local\Google\Chrome\User Data\Default\Cache\'
$varFolderArray += '\AppData\Local\Google\Chrome\User Data\Default\Media Cache\'
$varFolderArray += '\AppData\Local\Google\Chrome\User Data\Default\Pepper Data\'
$varFolderArray += '\AppData\Local\Microsoft\OneNote\14.0\OneNoteOfflineCache_Files\'
$varFolderArray += '\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\'
$varFolderArray += '\AppData\Local\Microsoft\Windows\Temporary Internet Files\Low\Content.IE5\'
$varFolderArray += '\AppData\Local\Microsoft\Windows\Temporary Internet Files\Virtualized\C\Users\'
$varFolderArray += '\AppData\Local\Microsoft\Windows\Windows Mail\'
$varFolderArray += '\AppData\Local\Temp\'
$varFolderArray += '\AppData\LocalLow\Google\GoogleEarth\'
$varFolderArray += '\Chrome\User Data\Default\Cache\'
$varFolderArray += '\Chrome\User Data\Default\Media Cache\'
$varFolderArray += '\Chrome\User Data\Default\Pepper Data\'
# below are wild card files to be tested later
#$varFolderArray += '\AppData\Local\Mozilla\Firefox\Profiles\*.default\Cache\'
#
# END PARAMETERS
#




# create easy to use date strings, includes zero-padding to 2 digits
$varCurrentDateTime = Get-Date
$varCurrentYear = $varCurrentDateTime.Year.ToString()
$varCurrentMonth = "0" + $varCurrentDateTime.Month.ToString()
$varCurrentMonth = $varCurrentMonth.Substring($varCurrentMonth.length - 2, 2)
$varCurrentDay = "0" + $varCurrentDateTime.Day.ToString()
$varCurrentDay = $varCurrentDay.Substring($varCurrentDay.length - 2, 2)
$varCurrentHour = "0" + $varCurrentDateTime.Hour.ToString()
$varCurrentHour = $varCurrentHour.Substring($varCurrentHour.length - 2, 2)
$varCurrentMinute = "0" + $varCurrentDateTime.Minute.ToString()
$varCurrentMinute = $varCurrentMinute.Substring($varCurrentMinute.length - 2, 2)
$varCurrentSecond = "0" + $varCurrentDateTime.Second.ToString()
$varCurrentSecond = $varCurrentSecond.Substring($varCurrentSecond.length - 2, 2)
$varCurrentDateTimeYYYYMMDDHHMMSS = $varCurrentYear + $varCurrentMonth + $varCurrentDay + $varCurrentHour + $varCurrentMinute + $varCurrentSecond

# script & log naming
$varScriptName = $MyInvocation.MyCommand.Name
$varScriptNameNoExtension = $varScriptName.Substring(0,$varScriptName.length - 5)
$varLogFileName = $varScriptNameNoExtension + "-" + $varCurrentDateTimeYYYYMMDDHHMMSS + ".log"
$varLogFileFullPath = $varLogFilePath + "\" + $varScriptNameNoExtension
$varLogFileFullName = $varLogFileFullPath + "\" + $varLogFileName

# check & create (if necessary) log file path
if (!(Test-Path -path $varLogFileFullPath))
{
     New-Item $varLogFileFullPath -type directory
}

# Check all setup is correct, send to log file.
$streamLogFile = [System.IO.StreamWriter] $varLogFileFullName
$streamLogFile.WriteLine("Script name:        " + $varScriptName)
$streamLogFile.WriteLine("Logfile name:       " + $varLogFileFullName)
$streamLogFile.WriteLine("Run date & time:    " + $varCurrentDateTimeYYYYMMDDHHMMSS)
$streamLogFile.WriteLine("Starting folder:    " + $varRootFolder)
$streamLogFile.Close()


# tell log we're starting
$varNow = Get-Date
$varLogMessage = "Starting file removal:  " + $varNow
Add-Content $varLogFileFullName $varLogMessage

# first loop is top folder to start checking, or where each profile directory starts
ForEach ($varFolderSearch in Get-ChildItem -Path $varRootFolder)
{
     $varPathToCheck = $varFolderSearch.FullName
     $varLogMessage = "Checking profile path:  " + $varPathToCheck
     Add-Content $varLogFileFullName $varLogMessage
     # now need to remove each file specified in $varFileArray
     For ($i=0; $i -le $varFileArray.Length -1; $i++)
     {
          $varFileToCheck = $varPathToCheck + $varFileArray[$i]
          if (Test-Path $varFileToCheck)
          {
               Remove-Item $varFileToCheck
               $varLogMessage = "Removed file:  " + $varFileToCheck
               Add-Content $varLogFileFullName $varLogMessage
          }
     }
     # now need to remove each file specified in $varFolderArray
     For ($i=0; $i -le $varFolderArray.Length -1; $i++)
     {
          $varFolderToCheck = $varPathToCheck + $varFolderArray[$i]
          if (Test-Path $varFolderToCheck)
          {
               $varFolderToRemove = $varFolderToCheck + "*"
               Remove-Item $varFolderToRemove -Recurse -Force
               $varLogMessage = "Emptied folder:  " + $varFolderToCheck
               Add-Content $varLogFileFullName $varLogMessage
          }
     }
}

# tell log we're finished
$varNow = Get-Date
$varLogMessage = "Finished file removal:  " + $varNow
Add-Content $varLogFileFullName $varLogMessage
