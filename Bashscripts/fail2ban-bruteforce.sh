# tips for fail2ban to protect against brute force attacks 
# install fail2ban on Linux
sudo apt install fail2ban  #  Debian/Ubuntu  
sudo dnf install fail2ban  #  RHEL/AlmaLinux/Fedora

# create config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# or just create it

sudo touch /etc/fail2ban/jail.local

# config example
###################################################
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log   # Debian/Ubuntu
#logpath = /var/log/secure   # RHEL/AlmaLinux
maxretry = 3
findtime = 600
bantime = 3600
###################################################

# start fail2ban
sudo systemctl enable --now fail2ban

# check status
sudo fail2ban-client status sshd


# unban ip manuaLLy
sudo fail2ban-client unban <IP>
# or ban manually
sudo fail2ban-client set sshd banip <IP>