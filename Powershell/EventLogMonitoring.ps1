# Event monitoring script to 
Get-EventLog -LogName System -Newest 10 | Where-Object { $_.EntryType -eq "Error" }