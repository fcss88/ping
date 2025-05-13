# startup time
$lastBootRaw = (Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime
$lastBootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($lastBootRaw)

# format the time in day, date, time
$lastBootTime.ToString("dddd, dd.MM.yyyy HH:mm:ss")

# ukrainian locale
[System.Threading.Thread]::CurrentThread.CurrentCulture = 'uk-UA'
$lastBootTime.ToString("dddd, dd.MM.yyyy HH:mm:ss")



# 
$bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$uptime = (Get-Date) - $bootTime
Write-Output "Last load: $($bootTime.ToString('yyyy-MM-dd HH:mm:ss (dddd)'))"
Write-Output "Uptime: $([math]::Round($uptime.TotalHours, 2)) hours"