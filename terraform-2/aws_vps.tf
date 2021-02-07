
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    "name" = "my_vpc"
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
# CREATE EIP
#---------------------------------------------------
resource "aws_eip" "eip_app" {
  vpc      = true
  instance = aws_instance.app.id
  tags = {
    "name" = "eip_app"
  }
}

resource "aws_eip" "eip_db" {
  vpc      = true
  instance = aws_instance.db.id
  tags = {
    "name" = "eip_db"
  }
}

resource "aws_route_table" "my_vpc_public" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Subnet Route Table."
  }
}

resource "aws_route_table_association" "sub_route" {
  count          = 2
  subnet_id      = aws_subnet.mysub[count.index].id
  route_table_id = aws_route_table.my_vpc_public.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "name" = "internet_gw"
  }
}
