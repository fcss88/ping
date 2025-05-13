@echo off
setlocal

:: check number of parameters
if "%~2" neq "" (
    echo ! Too many parameters passed. Please, enter one. Example: Clipboard.bat 123456
    goto end
)

if "%~1"=="" (
    echo ! No one parameter passed. Please, enter one. Example: Clipboard.bat 123456
    goto end
)

:: run owershell comand with parameter
powershell -Command "Set-Clipboard -Value '%~1'; Write-Host 'Text ''%~1'' successfully copied to clipboard.'"

:end
endlocal