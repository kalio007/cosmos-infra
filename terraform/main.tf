provider "aws" {
  region = var.aws_region
}
resource "aws_key_pair" "cosmos_keypair" {
  key_name   = "cosmos-key"
  public_key = "${var.key_path}.pub"
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "cosmos-node" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  key_name                    = aws_key_pair.cosmos_keypair.key_name
  vpc_security_group_ids      = [aws_security_group.cosmos_sg.id]
  associate_public_ip_address = true


  tags = {
    Name = "cosmos-infra"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_path}")
      host        = self.public_ip
    }

    inline = [
      "sudo adduser --disabled-password --gecos '' cosmosuser",
      "echo 'cosmosuser ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers",
      "sudo mkdir -p /home/cosmosuser/.ssh",
      "sudo cp /home/ubuntu/.ssh/authorized_keys /home/cosmosuser/.ssh/",
      "cat /home/cosmosuser/.ssh/cosmos.pub | sudo tee -a /home/cosmosuser/.ssh/authorized_keys",
      "sudo chown -R cosmosuser:cosmosuser /home/cosmosuser/.ssh"
    ]
  }

  provisioner "file" {
    source      = file("${var.key_path}.pub")
    destination = "/home/cosmosuser/.ssh/cosmos.pub"

    connection {
      type        = "ssh"
      user        = "ununtu"
      private_key = file("${var.key_path}")
      host        = self.public_ip
    }
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.key_path}")
      host        = self.public_ip
    }

    inline = [
      "sudo cat /home/cosmosuser/.ssh/cosmos.pub | sudo tee -a /home/cosmosuser/.ssh/authorized_keys",
    ]
  }
  provisioner "local-exec" {
    command = <<EOT
    mkdir -p ../ansible/inventory
    echo '[cosmos_nodes]' > ../ansible/inventory/hosts.ini
    echo '${self.public_ip}' >> ../ansible/inventory/hosts.ini
    EOT
  }
}



