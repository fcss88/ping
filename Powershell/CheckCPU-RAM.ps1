# check CPU and RAM usage
# describe variable
$cpu = Get-WmiObject Win32_Processor | Select-Object LoadPercentage
$ram = Get-WmiObject Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
$cpuLoad = $cpu.LoadPercentage
$ramUsed = [math]::round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory) / 1MB, 2)
$ramTotal = [math]::round($ram.TotalVisibleMemorySize / 1MB, 2)


Write-Output "CPU Load: $cpuLoad%"
Write-Output "RAM Usage: $ramUsed MB / $ramTotal MB"