@echo off
rem Phase 2 of defender.bat: runs once as SYSTEM on the first boot after the
rem Defender services were disabled, when their files are no longer in use.
set "LOG=C:\SynergyOS\Logs\DefenderCleanup.log"
if not exist "C:\SynergyOS\Logs" mkdir "C:\SynergyOS\Logs"

echo [%date% %time%] cleanup started >> "%LOG%"

for %%s in (MsSecCore MsSecFlt MsSecWfp SecurityHealthService Sense WdBoot WdFilter WdNisDrv WdNisSvc WinDefend wscsvc MDCoreSvc SgrmAgent SgrmBroker webthreatdefsvc webthreatdefusersvc) do sc delete %%s >> "%LOG%" 2>&1

for %%t in ("Windows Defender Cache Maintenance" "Windows Defender Cleanup" "Windows Defender Scheduled Scan" "Windows Defender Verification") do SchTasks.exe /Delete /F /TN "\Microsoft\Windows\Windows Defender\%%~t" >> "%LOG%" 2>&1

rd /s /q "C:\ProgramData\Microsoft\Windows Defender" >> "%LOG%" 2>&1
rd /s /q "C:\Program Files\Windows Defender" >> "%LOG%" 2>&1
rd /s /q "C:\Program Files (x86)\Windows Defender" >> "%LOG%" 2>&1
rd /s /q "C:\Program Files\Windows Defender Advanced Threat Protection" >> "%LOG%" 2>&1
del /f /q "C:\Windows\System32\drivers\wd\Wd*.sys" >> "%LOG%" 2>&1

echo [%date% %time%] cleanup finished >> "%LOG%"
rem shortcut: single attempt, no retry - if the log shows locked files (tamper
rem protection re-enabled the services), re-run the playbook manually.
SchTasks.exe /Delete /F /TN "SynergyOS-DefenderCleanup" >nul 2>&1
