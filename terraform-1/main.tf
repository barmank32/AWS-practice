#
# MAINTAINER
#
terraform {
  required_version = "> 0.12.0"
}
provider "aws" {
  region                  = var.zone
  shared_credentials_file = "~/.aws/credentials"
  # access_key = "${var.aws_access_key}"
  # secret_key = "${var.aws_secret_key}"
}

/* data "aws_ami" "my_ami" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.env}"]
  }

  most_recent = true
  owners      = ["self"]
} */

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-xenial*amd64*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  names = [
    aws_instance.app.tags.Name,
    aws_instance.db.tags.Name
  ]
  ips   = [
    aws_instance.app.public_ip,
    aws_instance.db.private_ip
  ]
}

resource "local_file" "generate_inventory" {
  content = templatefile("hosts.tpl", {
    names = local.names,
    addrs = local.ips,
    bastion = aws_instance.app.public_ip
    privat_key = var.privat_key
  })
  filename = "inventory"

  provisioner "local-exec" {
    command = "chmod a-x inventory"
  }

  provisioner "local-exec" {
    command = "cp -u inventory ../ansible/inventory"
  }

  provisioner "local-exec" {
    when = destroy
    command = "mv inventory inventory.backup"
    on_failure = continue
  }
}
