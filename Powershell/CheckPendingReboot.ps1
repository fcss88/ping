$statuses = @{}

# 1. Windows Update
$rebootKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
$statuses['Windows Update Reboot Required'] = Test-Path $rebootKey

# 2. PendingFileRenameOperations
$pendingFileRenameKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
$pendingFileRenames = Get-ItemProperty -Path $pendingFileRenameKey -Name 'PendingFileRenameOperations' -ErrorAction SilentlyContinue
$statuses['Pending File Rename Operations'] = $pendingFileRenames -ne $null

# 3. Pending Computer Rename
$computerNameKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName'
$activeName = (Get-ItemProperty -Path $computerNameKey).ComputerName
$pendingNameKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName'
$pendingName = (Get-ItemProperty -Path $pendingNameKey).ComputerName
$statuses['Pending Computer Rename'] = $activeName -ne $pendingName

# 4. Component-Based Servicing (CBS) 
$cbsRebootKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
$statuses['Component-Based Servicing Pending'] = Test-Path $cbsRebootKey

# Output results
Write-Output "=~~= Windows Update Status =~~="
foreach ($status in $statuses.Keys) {
    $symbol = if ($statuses[$status]) { "need restart" } else { "up to date" }
    Write-Output "$symbol $status"
}
