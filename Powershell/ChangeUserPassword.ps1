$localUser = "User1"
$securePassword = ConvertTo-SecureString "NewPassword_123" -AsPlainText -Force
Set-LocalUser -Name $localUser -Password $securePassword
Write-Output "Pass for $localUser changed successfully"