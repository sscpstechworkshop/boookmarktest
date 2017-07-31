rem This command will create a Task Scheduler task for the bell schedule powershell script.

schtasks /create /RU automator06 /SC MINUTE /MO 1 /TN BellSchedule /TR "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -file c:\TechTools\Scripts\bellschedule.ps1" /NP /RL HIGHEST
