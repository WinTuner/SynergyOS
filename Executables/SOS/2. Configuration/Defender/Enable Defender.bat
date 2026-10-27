@echo off
:: Run as administrator. Restores Defender (reverse of Disable Defender.bat).
:: NOTE: Smart App Control stays OFF (Windows cannot re-enable it without reinstall).
sc stop wscsvc >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "PassiveMode" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRealtimeMonitoring" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "SpyNetReporting" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "SubmitSamplesConsent" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /f >nul 2>&1
if exist "%ProgramFiles%\Windows Defender\MsMpEng.exee" ren "%ProgramFiles%\Windows Defender\MsMpEng.exee" "MsMpEng.exe" >nul 2>&1
if not exist "%ProgramFiles%\Windows Defender\MpCmdRun.exe" goto :missing
for %%z in (MsSecCore WdBoot WdFilter) do (
Reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" >nul 2>&1 && Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" /v "Start" /t REG_DWORD /d "0" /f >nul 2>&1
)
for %%z in (SecurityHealthService Sense WdNisDrv WdNisSvc webthreatdefsvc) do (
Reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" >nul 2>&1 && Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" /v "Start" /t REG_DWORD /d "3" /f >nul 2>&1
)
for %%z in (WinDefend webthreatdefusersvc wscsvc) do (
Reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" >nul 2>&1 && Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" /v "Start" /t REG_DWORD /d "2" /f >nul 2>&1
)
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /t REG_SZ /d "%windir%\system32\SecurityHealthSystray.exe" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /t REG_BINARY /d "020000000000000000000000" /f >nul 2>&1
for %%t in (
    "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
    "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
    "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
    "\Microsoft\Windows\Windows Defender\Windows Defender Verification"
) do (
schtasks /Change /TN %%t /Enable >nul 2>&1
)
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -EnableService >nul 2>&1
echo Defender enabled (Smart App Control stays off). Please restart your computer.
pause
exit /b 0
:missing
echo WARNING: Defender binaries are missing (fully removed) - restore them first, then run this again.
pause
exit /b 1
