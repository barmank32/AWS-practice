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

data "aws_availability_zones" "avalible" {}
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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "TEST-VPC"
  cidr   = var.vpc_cidr
  azs    = [data.aws_availability_zones.avalible.names[0]]
  private_subnets = [
    cidrsubnet(var.vpc_cidr, 4, 0),
    cidrsubnet(var.vpc_cidr, 4, 1)
  ]
  public_subnets = [cidrsubnet(var.vpc_cidr, 4, 10)]
  #NAT
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  #VPN
  enable_vpn_gateway = "false"
}
