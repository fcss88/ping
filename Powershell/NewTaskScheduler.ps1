# Add task to Windows Task Scheduler
# This script creates a scheduled task that opens Notepad every day at 9 AM
$action = New-ScheduledTaskAction -Execute "notepad.exe"
$trigger = New-ScheduledTaskTrigger -Daily -At 9am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "OpenNotepadDaily" -Description "Opens Notepad every day at 9 AM"