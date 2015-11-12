#################################################################################
#
# PURPOSE: When using folder redirection, $RECYCLE.BIN folders are created in
#          each redirected folder.  This will forcibly delete all files older
#          then the configured time frame.  
# USAGE:   This script is designed to be run without parameters.  Change the
#          variables at the beginning to define appropriate parameters. 
#
#          Logging will automatically create subfolder that is the name of the 
#          script and date & time stamped file with the name of the script in 
#          location found in the PARAMETERS section.  
#          E.g. \cleanup_files\cleanup_files-20130125235901.log
#
#          Running via Windows Task Scheduler:
#            powershell -file "C:\Tech_Stuff\Scripts\cleanup_recyclebin_30days.ps1"
# AUTHOR:  Ralph deGennaro
# HISTORY: 2013-01-24 - Ralph deGennaro - First created
#          2013-01-25 - Ralph deGennaro - added logging
#          2013-01-29 - Ralph deGennaro - fixes for Task Scheduler running;
#                       mostly additions of absolute paths
#################################################################################

#
# PARAMETERS
#
$varAgeDelete = 30
$varRootFolder = 'C:\Storage\UserFiles'
$varFolderToMatch = '$RECYCLE.BIN'
$varLogFilePath = 'C:\TechTools\Logs'

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

# open up log file stream
$streamLogFile = [System.IO.StreamWriter] $varLogFileFullName

# Check all setup is correct, send to log file.
$streamLogFile.WriteLine("Script name:        " + $varScriptName)
$streamLogFile.WriteLine("Logfile name:       " + $varLogFileFullName)
$streamLogFile.WriteLine("Run date & time:    " + $varCurrentDateTimeYYYYMMDDHHMMSS)
$streamLogFile.WriteLine("Starting folder:    " + $varRootFolder)
$streamLogFile.WriteLine("Folder to find:     " + $varFolderToMatch)
$streamLogFile.WriteLine("File age to delete: " + $varAgeDelete)

# now actually do the cleanup
ForEach ($varFolderSearch in Get-ChildItem -Path $varRootFolder -Filter $varFolderToMatch -Force -Recurse)
{
     $varPathToCheck = $varFolderSearch.FullName
     $streamLogFile.WriteLine("Checking path:  " + $varPathToCheck)
     Get-ChildItem $varPathToCheck -Force -Recurse -ErrorAction SilentlyContinue |
          Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } |
          Remove-Item -Force -Recurse
}
$streamLogFile.WriteLine("Finished checking folders.")

# cleanup
$streamLogFile.Close()
