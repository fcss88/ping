@echo off
setlocal

:: check parameters
if "%~2" neq "" (
    echo ! Too many parameters passed. Please, enter one. Example: Clipboard.bat 123456
    goto end
)

if "%~1"=="" (
    echo ! No one parameter passed. Please, enter one. Example: Clipboard.bat 123456
    goto end
)

:: send to clipboard via powershell
echo %~1 | clip

echo Text '%~1' successfully copied to clipboard.

:end
endlocal