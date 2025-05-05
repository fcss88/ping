# startup time
$lastBootRaw = (Get-WmiObject -Class Win32_OperatingSystem).LastBootUpTime
$lastBootTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($lastBootRaw)

# format the time in day, date, time
$lastBootTime.ToString("dddd, dd.MM.yyyy HH:mm:ss")

# ukrainian locale
[System.Threading.Thread]::CurrentThread.CurrentCulture = 'uk-UA'
$lastBootTime.ToString("dddd, dd.MM.yyyy HH:mm:ss")
