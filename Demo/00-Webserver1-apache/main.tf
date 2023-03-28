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

# CREATING host with apache
resource "linode_instance" "webserv-apache" {
  label = "apache"
  region = "eu-central"
  type = "g6-standard-1"
  image = "linode/debian11"
  root_pass = var.root_password_linode
  authorized_keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQAB/7WN04HD1AGaWLlPri/ZFEr4+jl rsa-key-20210708"]
  backups_enabled = false
  private_ip = false

  provisioner "remote-exec" {
   connection {
     type     = "ssh"
     user     = "root"
     password = var.root_password_linode
     host     = "${linode_instance.webserv-apache.ip_address}"
   }
    inline = [
      "apt update && apt full-upgrade -y && apt install apache2 -y && systemctl enable apache2",
    ]
  }

}

output "ip_address" {
  value = linode_instance.webserv-apache.ip_address
}

