# Create directory if it doesn't exist
$outputDir = ".\output"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Set the threshold for inactive users (6 months)
$inactiveThreshold = (Get-Date).AddMonths(-6)

# Create a timestamp for the CSV file name
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$csvFileName = "inactive_users_$timestamp.csv"
$csvPath = Join-Path $outputDir $csvFileName

# Get information about inactive users
Get-ADUser -Filter * -Properties LastLogonDate, WhenCreated, Enabled |
    Where-Object { $_.LastLogonDate -lt $inactiveThreshold } |
    Select-Object SamAccountName, LastLogonDate, WhenCreated, Enabled |
    Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Output "Report of inactive users saved in: $csvPath"
