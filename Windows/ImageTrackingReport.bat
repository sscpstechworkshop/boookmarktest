:: This batch job reports to the server defined the workstation name, date, time and image of this computer every reboot

:: Server to report to
SET server=DRACO

:: Image environment variable has been defined in each image

:: Format Date variable to YYYYMMDD
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET mm=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('echo %CDATE%') DO SET dd=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('echo %CDATE%') DO SET yyyy=%%B
SET date=%yyyy%%mm%%dd% 

:: Check for network connection
ping -n 1 draco|find "Reply from"
if not errorlevel 0 goto NoNetwork

:: Report data to server
echo %ComputerName% %date% %time% %image% > \\%server%\c$\TechTools\ImageTrackingLogs\%ComputerName%.log
goto end

:NoNetwork
echo %ComputerName% %date% %time% "No network connection detected for Image Tracking Process..." > c:\Windows\Logs\NO_NETWORK_%ComputerName%.log
goto end

:end
exit


