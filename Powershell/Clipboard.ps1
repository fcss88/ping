
if ($args.Count -eq 1) {
    Set-Clipboard -Value $args[0]
    Write-Output "Text '$($args[0])' successfully copied to clipboard."
}
elseif ($args.Count -eq 0) {
    Write-Output "! No one parameter passed. Please, enter one. Example: .\Clipboard.ps1 123456"
}

else {
    Write-Output "! Too many parameters passed. Please, enter one. Example: .\Clipboard.ps1 123456"
}