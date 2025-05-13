@echo off
setlocal enabledelayedexpansion

:: check parameters
if "%~1"=="" (
    echo ! No one parameter passed. Please, enter text. Example: Clipboard.bat This is a test
    goto end
)

:: combine all parameters into one string
set "text="
:loop
if "%~1"=="" goto copy
set "text=!text! %~1"
shift
goto loop

:copy
:: delete first space
set "text=!text:~1!"

:: copy to clipboard
echo !text! | clip
echo Text '!text!' successfully copied to clipboard.

:end
endlocal