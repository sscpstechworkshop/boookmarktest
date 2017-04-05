############################################################################
# School bell script
#
# This powershell script has been modeled after the bash BellSchedule script
# we have in place for the OSX devices
############################################################################

# Today's date and time
$date = Get-Date
$year = $date.Year                        # 2016
$month = $date.Month                      # 8
$dayOfMonth = $date.Day                   # 20
$day = $date.DayOfWeek                    # Friday
$hour = Get-Date -format HH               # 15 (24hr format, with leading zeros)
$minute = Get-Date -format mm             # 45 (with leading zeros)
$currentDate = $date.ToShortDateString()  # 1/5/2017
$currentTime = $hour + ":" + $min         # 15:45

$user = $env:username

#versionRemoteDir = "joetest"
#versionRemoteDir = "riotest"
$versionRemoteDir = "v2/lhs"
$confFile = "\Users\" + $user + "\AppData\Local\BellSchedule\bellschedule_settings.conf"
$scheduleURL = "http://files.sscps.org/bellschedule/" + $versionRemoteDir + "/bellschedule_" + $day + ".conf"
$scheduleFile = "\Users\" + $user + "\AppData\Local\BellSchedule\bellschedule_" + $day + ".conf"
$wavURL = "http://files.sscps.org/bellschedule/" + $versionRemoteDir + "/bellschedule.mp3"
$wavFile = "\Users\" + $user + "\AppData\Local\BellSchedule\bellschedule.wav"
$logPath = "\Users\" + $user + "\AppData\Local\BellSchedule\logs\"
$logFile = $logPath + "bellschedule.log"
# the higher the number, the more the information, read below for details
$logLevel = 5

function sendToLog {
   if ( $b -le $logLevel ) {
      Param ($a,$b)
      message = $currentDate + $currentTime + ":" + $a
      echo $message >> $logFile
   }
}

# create log folder if needed
if ( ! (Test-Path $logPath ) ) {
   New-Item $logPath -type Directory
   New-Item $logPath + "bellschedule.log" -type File
   sendToLog $logPath + "bellschedule.log created." 0
}

sendToLog "Start script" 0

# Check if config file exists and if so compare to today's date
if ( ! (Test-Path $confFile) ) {
   sendToLog "Settings file not found, creating it." 2
   echo $currentDate>$confFile
   sendToLog "Downloading schedule file for " + $day 1
   (New-Object System.Net.WebClient).DownloadFile($scheduleURL, $scheduleFile)
}
else {
   storedDate = Get-Content $confFile -First 1
   if ( $currentDate -eq $storedDate ) {
      sendToLog "bellschedule_settings.conf file has today's date." 1
   }
   else {
      echo $currentDate>$confFile
      (New-Object System.Net.WebClient).DownloadFile($scheduleURL, $scheduleFile)
   }
}

# Check if config file is valid.   Is its file size 0?
if ( (Get-Item $confFile).Length -eq 0) {
   sendToLog "Zero sized " + $scheduleFile + ", removing " + $confFile + " for redownload." 2
   Remove-Item $confFile
}

# Check if .wav file exists and isn't 0 sized
if ( ! (Test-Path $wavFile) ) {
   sendToLog "WAV not found, downloading..." 2
   (New-Object System.Net.WebClient).DownloadFile($wavURL, $wavFile)
}
else {
   if ( (Get-Item $wavFile).Length -eq 0 ) {
      sendToLog "Zero sized " + $wavFile + ", redownload." 2
      (New-Object System.Net.WebClient).DownloadFile($wavURL, $wavFile)
   }
   else {
      sendToLog "WAV file found & non-zero, no need to download." 3
   }
}

# Give the possible download(s) a moment to finish
sendToLog "Sleeping for 5 seconds..." 4
Start-Sleep -s 5
sendToLog "...done sleeping for 5 seconds" 4

# populate scheduleArray from scheduleFile
sendToLog "Checking if scheduleFile exists" 5
if ( ! (Test-Path $scheduleFile) ) {
   sendToLog $scheduleFile + " doesn't exist!   Exiting." 0
   Exit
}
else {
   sendToLog "Found " + $scheduleFile 5
   $scheduleArray = Import-CSV $scheduleFile
}

sendToLog "Before loop that finds bell schedule" 5

Foreach ($i in $scheduleArray) {
   sendToLog "Line being tested is: $i" 4
   $currentTimeArray = $i
   #sendToLog "currentTimeArray is: $currentTimeArray[*]}" 5
   if ( $currentTimeArray[0] = "default" ) {
      # Using arrayList here so we can remove 0 element (yes, that comma is supposed to be there)
      $bellscheduleArrayList = New-Object System.Collections.ArrayList(,$currentTimeArray)
      sendToLog "Using default bellScheduleArrayList: " + $bellScheduleArrayList[*] 1
      $bellScheduleArrayList.RemoveAt(0)
   }
   sendToLog "Current date is: $currentDate" 5
   if ( $currentTimeArray[0] = $currentDate ) {
      $bellscheduleArrayList = New-Object System.Collections.ArrayList(,$currentTimeArray)
      sendToLog "Changing to custom bellScheduleArrayList: " + $bellScheduleArrayList[*] 1
      $bellScheduleArrayList.RemoveAt(0)
   }
}

sendToLog "Final bellSchedule array is: " + $bellScheduleArrayList[*] 0

# if bellSchedule has no times, exit
if ( $bellScheduleArrayList[@] -eq 0 ) {
    sendToLog "Schedule has no times.  Exiting." 0
    exit 0
}

Foreach ($time in $bellScheduleArrayList[@]) {
   sendToLog "Time comparison is between : time= " + $time + "currentTime= " + $currentTime 4
   if ( $time -eq $currentTime ) {
      $bell = new-Object System.Media.SoundPlayer
      $bell.SoundLocation = $wavFile
      $bell.Play()
      exit 0
   }
}
