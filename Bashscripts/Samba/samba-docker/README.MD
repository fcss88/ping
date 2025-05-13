# Samba in container

## Run
```bash
cd samba-docker
docker compose up --build -d
```
## Users
+ **sambauser1**
+ **sambauser2**
+ **guest** without password
## Directories needed
+ **./shared** - shared directory
+ **./logs** - logs directory

## Ports
+ 137..139 old NetBios ports [for WinXP/Win2003 clients or other older OS]
+ 445 Default Samba port [SMBv2, SMBv3]

## check_smb_support.sh
run scripts with parameter like this
```
./check_smb_support.sh 192.168.1.1 # for ip
./check_smb_support.sh hostname1 # for hostname
```
**nmap** util install needed

```
sudo apt update $$ sudo apt install nmap -y
``