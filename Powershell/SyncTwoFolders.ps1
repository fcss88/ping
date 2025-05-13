# descript two variables
$source = "C:\SourceFolder"
$destination = "C:\BackupFolder"

# compare two directories
# MIR - Mirror a complete directory tree in 2 locations
# /E - Copy all subdirectories, including empty ones
Robocopy $source $destination /MIR