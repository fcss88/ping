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

# CREATING host with nginx
resource "linode_instance" "webserv-nginx" {
  label = "nginx"
  region = "eu-central"
  type = "g6-standard-1"
  image = "linode/debian11"
  root_pass = var.root_password_linode
  authorized_keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmT8F/7WN04HD1AGaWLlPri/ZFEr4+jl rsa-key-20210708"]
  backups_enabled = false
  private_ip = false

  provisioner "remote-exec" {
   connection {
     type     = "ssh"
     user     = "root"
     password = var.root_password_linode
     host     = "${linode_instance.webserv-nginx.ip_address}"
   }
    inline = [
      "apt update && apt full-upgrade -y && apt install nginx -y && systemctl enable nginx",
    ]
  }

}

output "ip_address" {
  value = linode_instance.webserv-nginx.ip_address
}

