::==  This copies files via ROBOCOPY and logs the ROBOCOPY output.
::==  Assumes C:\TechTools\Scripts and C:\TechTool\Logs are already created.
::==    

::== setup environment
@echo off
cls
setLocal EnableDelayedExpansion
echo =================================
echo Copy files using robocopy
echo Logging at C:\TechTool\Logs
echo =================================

::== get date/time for today
REM Month is odd because DOS variable & commands are odd.
FOR /F "TOKENS=1* DELIMS= " %%A IN ('DATE/T') DO SET CDATE=%%B
FOR /F "TOKENS=1,2 eol=/ DELIMS=/ " %%A IN ('DATE/T') DO SET vMonth=%%B
FOR /F "TOKENS=1,2 DELIMS=/ eol=/" %%A IN ('echo %CDATE%') DO SET vDay=%%B
FOR /F "TOKENS=2,3 DELIMS=/ " %%A IN ('echo %CDATE%') DO SET vYear=%%B
FOR /F "TOKENS=1 DELIMS=: " %%h IN ('echo %TIME%') DO SET vHour=%%h
FOR /F "TOKENS=2 DELIMS=: " %%m IN ('echo %TIME%') DO SET vMin=%%m
FOR /F "TOKENS=3,4 DELIMS=:. " %%s IN ('echo %TIME%') DO SET vSec=%%s
::== fix hour variable (adds leading zero and takes last 2 digits)
set vHour=0%vHour%
set vHour=%vHour:~-2%
::== trim each variable
set vMonth=%vMonth: =%
set vDay=%vDay: =%
set vYear=%vYear: =%
set vHour=%vHour: =%
set vMin=%vMin: =%
set vSec=%vSec: =%
::== put date/time together in various formats
set vDate=%vYear%%vMonth%%vDay%%vHour%%vMin%%vSec%
set vDateTimeYYYYMMDDHHMMSS=%vYear%%vMonth%%vDay%%vHour%%vMin%%vSec%
set vDateTimeYYYYMMDD=%vYear%%vMonth%%vDay%
set vDateMMDDYYYY=%vMonth%%vDay%%vYear%
set vDateMMDDYYYYDel=%vMonth%/%vDay%/%vYear%
set vTimeHHMMSS=%vHour%%vMin%%vSec%
set vTimeHHMMSSDel=%vHour%:%vMin%:%vSec%
set vTimeHHMM=%vHour%%vMin%
set vTimeHHMMDel=%vHour%:%vMin%
set vDateM-D-Y=%vMonth%-%vDay%-%vYear%
echo !vDate!
::==

::== SAMPLE
REM robocopy C:\ToArchive\Backups\FY2011 E:\Backups\FY2011 /E /ZB /R:20 /W:60 /FP /NP /LOG+:C:\TechTools\Logs\temp_move_files-!vDate!.log

