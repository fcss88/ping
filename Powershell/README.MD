# Powershell
just few PS-scripts and tricks. enjoy -)



## Map-SambaDrive.ps1 example usage
### Map a drive with credentials
``` .\Map-SambaDrive.ps1 -Server 192.168.1.100 -Share "shared" -DriveLetter Z -Username "sambauser" -Password "pass123"```
### Map a drive without credentials
```.\Map-SambaDrive.ps1 -Server 192.168.1.100 -Share "public" -DriveLetter Z```


## ArgPingHost.ps1 example usage
```
ArgPingHost.ps1 192.168.0.1 # for ip
ArgPingHost.ps1 google.ua # for website or hostname
```