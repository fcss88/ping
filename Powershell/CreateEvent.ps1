# Create an event log and write an entry to it
# This script creates a new event log source and writes an entry to the Application log.
New-EventLog -LogName "Application" -Source "MyScript"
Write-EventLog -LogName "Application" -Source "MyScript" -EventID 1000 -EntryType Information -Message "PowerShell script executed successfully."