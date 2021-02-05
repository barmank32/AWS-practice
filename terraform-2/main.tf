#
# MAINTAINER
#
terraform {
  required_version = "> 0.12.0"
}
provider "aws" {
  region                  = var.zone
  shared_credentials_file = "~/.aws/credentials"
}

# data "aws_availability_zones" "avalible" {}
# data "aws_vpc" "def" {}

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




