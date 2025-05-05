# Create a new Active Directory user with PowerShell
$firstName = "John"
$lastName = "Doe"
$userName = "$firstName.$lastName"
$password = "P@ssw0rd"

New-ADUser `
    -Name "$firstName $lastName" `
    -GivenName $firstName `
    -Surname $lastName `
    -SamAccountName $userName `
    -UserPrincipalName "$userName@yourdomain.com" `
    -Path "OU=Users,DC=yourdomain,DC=com" `
    -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) `
    -Enabled $true
