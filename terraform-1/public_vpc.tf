#---------------------------------------------------
# Add AWS internet gateway
#---------------------------------------------------
resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "VPC - Internet Gateway"
  }
}

#---------------------------------------------------
# Add AWS subnet (public)
#---------------------------------------------------
resource "aws_route_table" "my_vpc_public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }

  tags = {
    Name = "Public Subnet Route Table."
  }
}

#---------------------------------------------------
# CREATE EIP
#---------------------------------------------------
resource "aws_eip" "aws_eip" {
    vpc         = true
    # depends_on = aws_internet_gateway.my_vpc_igw
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.app.id
  allocation_id = aws_eip.aws_eip.id
}

#---------------------------------------------------
# CREATE NAT
#---------------------------------------------------
# resource "aws_nat_gateway" "aws_nat_gateway" {
#     allocation_id = aws_eip.aws_eip.id
#     subnet_id = aws_subnet.my_subnet.id
#     # depends_on = aws_internet_gateway.my_vpc_igw
# }



# resource "aws_route_table_association" "my_vpc_public" {
#   subnet_id      = aws_subnet.my_subnet.id
#   route_table_id = aws_route_table.my_vpc_public.id
# }

/* resource "aws_security_group" "allow_ports" {
  name                   = "allow_ports_sg"
  description            = "Allow ports inbound connections"
  vpc_id                 = aws_vpc.my_vpc.id
  revoke_rules_on_delete = true

  dynamic "ingress" {
  for_each = toset(["22", "9292"])
  content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ports_sg"
  }
}
 */