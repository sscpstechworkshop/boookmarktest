############################################################################
# School bell script
#
# This powershell script has been modeled after the bash BellSchedule 
# script we have in place for the OSX devices
############################################################################

# Today's date and time
$date = Get-Date
$year = $date.Year                        # 2016
$month = Get-Date -format MM              # 08 (month with leading zeros)
$dayOfMonth = Get-Date -format dd         # 20 (day of month with leading zeros)
$day = $date.DayOfWeek                    # Friday
$hour = Get-Date -format HH               # 15 (24hr format, with leading zeros)
$minute = Get-Date -format mm             # 45 (with leading zeros)
$currentDate = $date.ToShortDateString()  # 1/5/2017
$currentTime = $hour + ":" + $minute      # 15:45

#versionRemoteDir = "joetest"
#versionRemoteDir = "riotest"
$versionRemoteDir = "v2/middle-school"
$confFile = "c:\TechTools\Scripts\BellSchedule\bellschedule_settings.conf"
$scheduleURL = "http://files.sscps.org/bellschedule/$versionRemoteDir/bellschedule_$day.conf"
$scheduleFileRaw = "c:\TechTools\Scripts\BellSchedule\bellschedule_" + $day + "_Raw.conf"
$scheduleFile = "c:\TechTools\Scripts\BellSchedule\bellschedule_$day.conf"
$wavURL = "http://files.sscps.org/bellschedule/$versionRemoteDir/bellschedule.wav"
$wavFile = "c:\Techtools\Scripts\BellSchedule\bellschedule.wav"
$logPath = "c:\Techtools\Scripts\BellSchedule\logs\"
$logFile = $logPath + "bellschedule.log"
# Turn logging off or on
$logging = 1

function sendToLog {
   param( $a )
   if ( $logging ) {
      $message = $currentDate + " " + $currentTime + ":" + $a
      echo $message >> $logFile
   }
}

# create log folder if needed
if ( ! (Test-Path $logPath ) ) {
   New-Item $logPath -type Directory
   New-Item $logPath\bellschedule.log -type File
   sendToLog $logPath + "bellschedule.log created."
}

sendToLog "Start script"

# Check if config file exists and if so compare to today's date
if ( ! (Test-Path $confFile) ) {
   sendToLog "Settings file not found, creating it."
   $currentDate | Set-Content $confFile
   sendToLog "Downloading schedule file for $day"
   (New-Object System.Net.WebClient).DownloadFile($scheduleURL, $scheduleFileRaw)
   (gc $scheduleFileRaw) | %{$_.split("`n")} | Out-File $scheduleFile
}
else {
   $storedDate = Get-Content $confFile -First 1
   if ( $currentDate -eq $storedDate ) {
      sendToLog "bellschedule_settings.conf file has today's date."
   }
   else {
      $currentDate | Set-Content $confFile
      (New-Object System.Net.WebClient).DownloadFile($scheduleURL, $scheduleFileRaw)
      (gc $scheduleFileRaw) | %{$_.split("`n")} | Out-File $scheduleFile
   }
}

# Check if config file is valid.   Is its file size 0?
if ( (Get-Item $confFile).Length -eq 0) {
   sendToLog "Zero sized $scheduleFile , removing $confFile for redownload."
   Remove-Item $confFile
}

# Check if .wav file exists and isn't 0 sized
if ( ! (Test-Path $wavFile) ) {
   sendToLog "WAV not found, downloading..."
   (New-Object System.Net.WebClient).DownloadFile($wavURL, $wavFile)
}
else {
   if ( (Get-Item $wavFile).Length -eq 0 ) {
      sendToLog "Zero sized $wavFile , redownload."
      (New-Object System.Net.WebClient).DownloadFile($wavURL, $wavFile)
   }
   else {
      sendToLog "WAV file found & non-zero, no need to download."
   }
}

# Give the possible download(s) a moment to finish
sendToLog "Sleeping for 5 seconds..."
Start-Sleep -s 5
sendToLog "...done sleeping for 5 seconds"

# populate scheduleArray from scheduleFile
sendToLog "Checking if scheduleFile exists"
if ( ! (Test-Path $scheduleFile) ) {
   sendToLog "$scheduleFile doesn't exist!   Exiting."
   Exit
}
else {
   sendToLog "Found scheduleFile $scheduleFile"
   # Build array.   First element will be the entire first line 
   $scheduleArray = Get-Content $scheduleFile
}

Foreach ($i in $scheduleArray) {
   sendToLog "Line from scheduleFile is: $i"
   # currentTimeArray will be values from scheduleArray (default, 08:01, etc)
   $currentTimeArray = $i -split ','
   sendToLog "currentTimeArray is: $currentTimeArray"
   if ( $currentTimeArray[0] -eq "default" ) {
      # Using arrayList here so we can remove 0 element (yes, that comma is supposed to be there)
      $bellscheduleArrayList = New-Object System.Collections.ArrayList(,$currentTimeArray)
      sendToLog "Using default bellScheduleArrayList: $bellScheduleArrayList"
      $bellScheduleArrayList.RemoveAt(0)
   }
   sendToLog "Current date is: $currentDate"
   if ( $currentTimeArray[0] -eq $currentDate ) {
      $bellscheduleArrayList = New-Object System.Collections.ArrayList(,$currentTimeArray)
      sendToLog "Changing to custom bellScheduleArrayList: $bellScheduleArrayList"
      # Remove "default" or exception date from first element
      $bellScheduleArrayList.RemoveAt(0)
   }
}

sendToLog "Final bellSchedule array is: $bellScheduleArrayList"

# if bellSchedule has no times, exit
if ( $bellScheduleArrayList.Count -eq 0 ) {
    sendToLog "Schedule has no times.  Exiting."
    exit 0
}

Foreach ($time in $bellScheduleArrayList) {
   sendToLog "Time comparison is between : time= $time currentTime= $currentTime"
   if ( $time -eq $currentTime ) {
      $bell = New-Object System.Media.SoundPlayer $wavFile
      $bell.PlaySync()
      exit 0
   }
}
