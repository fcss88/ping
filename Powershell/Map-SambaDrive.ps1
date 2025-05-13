param (
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$true)][string]$Share,
    [Parameter(Mandatory=$true)][string]$DriveLetter,
    [string]$Username,
    [string]$Password
)

$remotePath = "\\$Server\$Share"

# delete drive letter if it exists
if (Test-Path "${DriveLetter}:\") {
    Write-Host "Disconnecting $DriveLetter..."
    net use "{$DriveLetter}:" /delete /y | Out-Null
}

# create drive letter
if ($Username -and $Password) {
    cmd /c "net use ${DriveLetter}: $remotePath $Password /user:$Username /persistent:no"
} else {
    cmd /c "net use ${DriveLetter}: $remotePath /persistent:no"
}

# check connection
if (Test-Path "${DriveLetter}:\") {
    Write-Host "Share $remotePath mapped to ${DriveLetter}:`"
} else {
    Write-Host "Failed to map $remotePath to ${DriveLetter}:`"
}


## # Example usage
## # Map a drive with credentials
# .\Map-SambaDrive.ps1 -Server 192.168.1.100 -Share "shared" -DriveLetter Z -Username "sambauser" -Password "pass123"
## # Map a drive without credentials
# .\Map-SambaDrive.ps1 -Server 192.168.1.100 -Share "public" -DriveLetter Z
