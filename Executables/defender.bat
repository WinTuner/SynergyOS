@echo off
setlocal enabledelayedexpansion

set "LOGDIR=C:\SynergyOS\Logs"
set "LOGFILE=%LOGDIR%\DisableDefenderServices.log"
set "MINSUDO=%windir%\MinSudo.exe"

if not exist "%LOGDIR%" mkdir "%LOGDIR%"


call :log "Starting Defender.bat"

for %%z in (
      MsSecCore
      MsSecFlt
      MsSecWfp
      SecurityHealthService
      Sense
      WdBoot
      WdFilter
      WdNisDrv
      WdNisSvc
      WinDefend
      wscsvc
      MDCoreSvc
      SgrmAgent
      SgrmBroker
      webthreatdefsvc
      webthreatdefusersvc
) do (
    call :log "Processing service: %%z"
    rem query first - reg add would otherwise create junk keys for services this build doesn't have
    "%MINSUDO%" --NoLogo --TrustedInstaller --Privileged cmd /c "Reg.exe query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" >nul 2>&1 && Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" /v "Start" /t REG_DWORD /d "4" /f" >> "%LOGFILE%" 2>&1
    if !errorlevel! equ 0 (
        call :log "  SUCCESS: %%z set to Start=4"
    ) else (
        call :log "  SKIP: %%z not present or could not be set"
    )
)

rem the binaries are locked while this session still has the services loaded, so
rem deletion runs once as SYSTEM on the next boot - stage + schedule it here
if not exist "C:\SynergyOS" mkdir "C:\SynergyOS"
rem skip the copy when the playbook already runs from C:\SynergyOS (copy would fail onto itself)
if /i not "%~dp0defender-cleanup.bat"=="C:\SynergyOS\defender-cleanup.bat" copy /y "%~dp0defender-cleanup.bat" "C:\SynergyOS\defender-cleanup.bat" >> "%LOGFILE%" 2>&1
if exist "C:\SynergyOS\defender-cleanup.bat" (
    call :log "  SUCCESS: cleanup script staged"
) else (
    call :log "  ERROR: could not stage defender-cleanup.bat"
)

"%MINSUDO%" --NoLogo --TrustedInstaller --Privileged cmd /c "SchTasks.exe /Create /F /TN "SynergyOS-DefenderCleanup" /SC ONSTART /RU SYSTEM /TR "C:\SynergyOS\defender-cleanup.bat"" >> "%LOGFILE%" 2>&1
if !errorlevel! equ 0 (
    call :log "  SUCCESS: cleanup scheduled for next boot"
) else (
    call :log "  ERROR: cleanup task could not be created"
)

call :log "Completed DisableDefenderServices.bat"


endlocal
exit /b 0

:log
echo %~1
echo [%date% %time%] %~1 >> "%LOGFILE%"
exit /b 0