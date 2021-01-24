#
# MAINTAINER
#
terraform {
  required_version = "> 0.9.0"
}
provider "aws" {
  region                  = var.zone
  shared_credentials_file = "~/.aws/credentials"
  # access_key = "${var.aws_access_key}"
  # secret_key = "${var.aws_secret_key}"
}

data "aws_ami" "my_ami" {
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
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-xenial*amd64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
