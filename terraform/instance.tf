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

resource "aws_instance" "server" {
  ami           = data.aws_ami.my_ami.id
  instance_type = "t2.nano"
  key_name      = aws_key_pair.user.key_name
  #  Public
  vpc_security_group_ids      = [aws_security_group.allow_ports.id]
  subnet_id                   = aws_subnet.my_subnet.id
  associate_public_ip_address = true

  connection {
    type  = "ssh"
    host  = self.public_ip
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file("~/.ssh/appuser")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl restart mongod"
    ]
  }
}

resource "aws_key_pair" "user" {
  key_name   = "ubuntu-key"
  public_key = file("~/.ssh/appuser.pub")
}
