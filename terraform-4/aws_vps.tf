resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    "Name" = "my_vpc"
  }
}

resource "aws_subnet" "mysub" {
  count      = 2
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = cidrsubnet(aws_vpc.myvpc.cidr_block, 4, count.index)
  tags = {
    "Name" = "mysub-${count.index}"
  }
}
#---------------------------------------------------
# CREATE Private Route
#---------------------------------------------------
resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.myvpc.id

    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws_nat_gateway.id
  }

  tags = {
    Name = "Private Subnet Route Table."
  }
}

resource "aws_route_table_association" "privat_route" {
  count          = 2
  subnet_id      = aws_subnet.mysub[count.index].id
  route_table_id = aws_route_table.route_private.id
}
#---------------------------------------------------
# CREATE EIP
#---------------------------------------------------
resource "aws_eip" "eip_bastion" {
  vpc      = true
  instance = aws_instance.bastion.id
  tags = {
    "Name" = "eip_bastion"
  }
}

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Private Subnet Route Table."
  }
}

resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.pub_sub.id
  route_table_id = aws_route_table.route_public.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "internet_gw"
  }
}
#---------------------------------------------------
# CREATE NAT GW
#---------------------------------------------------
resource "aws_subnet" "pub_sub" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = cidrsubnet(aws_vpc.myvpc.cidr_block, 4, 10)
  tags = {
    "Name" = "pub_sub"
  }
}

resource "aws_eip" "eip_natgw" {
  vpc = true
  tags = {
    "Name" = "eip_nat_GW"
  }
}

resource "aws_nat_gateway" "aws_nat_gateway" {
  allocation_id = aws_eip.eip_natgw.id
  subnet_id     = aws_subnet.pub_sub.id
  depends_on    = [aws_internet_gateway.gw]
  tags = {
    Name = "gw NAT"
  }
}
