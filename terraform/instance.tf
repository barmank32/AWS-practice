resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "${var.zone}a"
  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "my_net" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.my_ami.id
  instance_type = "t2.nano"

  network_interface {
    network_interface_id = aws_network_interface.my_net.id
    device_index         = 0
  }

  #   credit_specification {
  #     cpu_credits = "unlimited"
  #   }
}
