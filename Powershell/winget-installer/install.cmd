@echo off
setlocal

echo Starting Winget Installer...

REM Path to the script directory
set SCRIPT_DIR=%~dp0

REM Run PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%install-packages.ps1"

endlocal
pause