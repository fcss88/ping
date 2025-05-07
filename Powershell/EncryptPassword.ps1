$securePassword = ConvertTo-SecureString "My_SecretPassw0rd" -AsPlainText -Force
$securePassword | ConvertFrom-SecureString | Out-File "output\encryptedPassword.txt"
Write-Output "Password encrypt and save."



# read the encrypted password from the file
$encryptedPassword = Get-Content "output\encryptedPassword.txt" -Raw

# convert the encrypted password back to a SecureString
$securePassword = ConvertTo-SecureString $encryptedPassword

# convert SecureString to plaintext
$unsecurePassword = [System.Net.NetworkCredential]::new("", $securePassword).Password

Write-Output "Encrypt password: $unsecurePassword"