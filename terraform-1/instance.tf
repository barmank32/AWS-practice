resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "VPC-Public"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "${var.zone}a"
  tags = {
    Name = "Subnet-public"
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.user.key_name
  #  Public
  vpc_security_group_ids      = [aws_security_group.allow_ports.id]
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true
  tags = {
    Name = "app-server"
  }
}

resource "aws_instance" "db" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.user.key_name
  #  Public
  vpc_security_group_ids      = [aws_security_group.allow_ports.id]
  subnet_id = aws_subnet.my_subnet.id
  # associate_public_ip_address = true
  tags = {
    Name = "db-server"
  }
}


resource "aws_key_pair" "user" {
  key_name   = "ubuntu-key"
  public_key = file(var.public_key)
}
