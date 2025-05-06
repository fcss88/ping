# update ps modules

# get all installed modules
$modules = Get-InstalledModule

# update all installed modules
foreach ($module in $modules) {
    Update-Module -Name $module.Name
}

Write-Output "your modules are updated"