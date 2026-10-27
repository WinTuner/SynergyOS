@echo off
:: Run as administrator. Post-install Defender off-switch (playbook leaves Defender on by default).
:: If Tamper Protection is ON, turn it off first: Windows Security - Virus and threat protection - Manage settings.
:: NOTE: this also turns Smart App Control OFF permanently (Windows can only re-enable it after reinstall).
set "TP="
for /f "tokens=3" %%v in ('reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v TamperProtection 2^>nul') do set "TP=%%v"
if /i not "%TP%"=="0x4" goto :blocked
sc stop wscsvc >nul 2>&1
Reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "PassiveMode" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "SubmitSamplesConsent" /t REG_DWORD /d "0" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f >nul 2>&1
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -DisableService >nul 2>&1
set /a TRIES=0
:waitwd
sc query WdFilter | find /i "STOPPED" >nul 2>&1
if not errorlevel 1 goto :wdstopped
set /a TRIES+=1
if %TRIES% GEQ 15 goto :wdstopped
timeout /t 1 /nobreak >nul
goto :waitwd
:wdstopped
taskkill /f /im SecurityHealthSystray.exe >nul 2>&1
sc stop SecurityHealthService >nul 2>&1
sc stop webthreatdefsvc >nul 2>&1
sc stop webthreatdefusersvc >nul 2>&1
for %%z in (MsSecCore SecurityHealthService Sense WdBoot WdFilter WdNisDrv WdNisSvc WinDefend webthreatdefsvc webthreatdefusersvc wscsvc) do (
Reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" >nul 2>&1 && Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" /v "Start" /t REG_DWORD /d "4" /f >nul 2>&1
)
if exist "%ProgramFiles%\Windows Defender\MsMpEng.exe" ren "%ProgramFiles%\Windows Defender\MsMpEng.exe" "MsMpEng.exee" >nul 2>&1
Reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v "VerifiedAndReputablePolicyState" /t REG_DWORD /d "0" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul 2>&1
Reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /f >nul 2>&1
for %%t in (
    "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
    "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
    "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
    "\Microsoft\Windows\Windows Defender\Windows Defender Verification"
) do (
schtasks /Change /TN %%t /Disable >nul 2>&1
)
echo Defender disabled. Please restart your computer.
pause
exit /b 0
:blocked
echo Blocked. Run as administrator and turn off Tamper Protection first:
echo Windows Security - Virus and threat protection - Manage settings.
pause
exit /b 1
