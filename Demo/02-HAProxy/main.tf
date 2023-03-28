terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.30.0"
    }
  }
}

#  Linode provider API-key
provider "linode" {
  token = var.token_linode
}

# CREATING host with haproxy
resource "linode_instance" "haproxy" {
  label = "haproxy"
  region = "eu-central"
  type = "g6-standard-1"
  image = "linode/debian11"
  root_pass = var.root_password_linode
  authorized_keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmT8/7WN04HD1AGaWLlPri/ZFEr4+jl rsa-key-20210708"]
  backups_enabled = false
  private_ip = false

  provisioner "remote-exec" {
   connection {
     type     = "ssh"
     user     = "root"
     password = var.root_password_linode
     host     = "${linode_instance.haproxy.ip_address}"
   }
    inline = [
      "apt update && apt full-upgrade -y && apt install haproxy -y && systemctl enable haproxy && apt install curl -y && apt install wget -y && apt install links -y && apt install links2 -y && apt install mc -y && apt install dnsutils -y && apt install whois -y && apt install htop -y",
      "cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bckp"    
    ]
  }

}

output "ip_address" {
  value = linode_instance.haproxy.ip_address
}