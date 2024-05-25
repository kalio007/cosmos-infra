terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

resource "digitalocean_droplet" "cosmos-node" {
  image  = "ubuntu-20-04-x64"
  name   = "cosmos-node"
  region = "nyc1"
  size   = "s-1vcpu-2gb"
  ssh_keys = var.ssh_keys

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("~/.ssh/samuel")  # Replace with your private key path
      host     = self.ipv4_address
    }

    inline = [
      "adduser --disabled-password --gecos '' cosmosuser",
      "echo 'cosmosuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers",
      "mkdir -p /home/cosmosuser/.ssh",
      "cp /root/.ssh/authorized_keys /home/cosmosuser/.ssh/",
      "cat /home/cosmosuser/.ssh/samuel.pub >> /home/cosmosuser/.ssh/authorized_keys",
      "chown -R cosmosuser:cosmosuser /home/cosmosuser/.ssh"
    ]
  }

  provisioner "file" {
    source      = "~/.ssh/samuel.pub"
    destination = "/home/cosmosuser/.ssh/samuel.pub"

    connection {
      type     = "ssh"
      user     = "root"
      private_key = file("~/.ssh/samuel")  # Replace with your private key path
      host     = self.ipv4_address
    }
  }

  provisioner "local-exec" {
    command = <<EOT
    mkdir -p ../ansible/inventory
    echo '[cosmos_nodes]' > ../ansible/inventory/hosts.ini
    echo '${self.ipv4_address} ansible_user=cosmosuser' >> ../ansible/inventory/hosts.ini
    EOT
  }
}

output "droplet_ip" {
  value = digitalocean_droplet.cosmos-node.ipv4_address
}
