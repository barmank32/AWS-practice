
resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.user.key_name
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  subnet_id              = aws_subnet.mysub[0].id
  tags = {
    Name = "app-server"
  }
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.user.key_name
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  subnet_id              = aws_subnet.mysub[1].id
  tags = {
    Name = "db-server"
  }
}

resource "aws_key_pair" "user" {
  key_name   = "ubuntu-key"
  public_key = file(var.public_key)
}

resource "aws_security_group" "allow_ports" {
  name                   = "allow_ports_sg"
  description            = "Allow ports inbound connections"
  vpc_id                 = aws_vpc.myvpc.id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "ICMP"
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
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
