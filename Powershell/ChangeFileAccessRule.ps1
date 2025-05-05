# get file permissions
$acl = Get-Acl "C:\example\file.txt"

# New permission to add
# DOMAIN\User User and\or Group to add permissions for. also can be a ComputerName\UserName or just UserName
# FullControl, ReadAndExecute, Read, Write, Modify, ListFolderContents, ReadAttributes, ReadPermissions, WriteAttributes, WriteExtendedAttributes, Delete, DeleteSubdirectoriesAndFiles, Synchronize, ChangePermissions, TakeOwnership
# Allow or Deny
# is the user or group you want to add permissions for
$permission = "DOMAIN\User", "FullControl", "Allow"

# Create a new FileSystemAccessRule object
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission

# Add the new rule to the ACL 
$acl.SetAccessRule($accessRule)

# Apply the updated ACL to the file
Set-Acl "C:\example\file.txt" $acl


