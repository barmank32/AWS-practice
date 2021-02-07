variable env {
  # Значение по умолчанию
  default = "prd"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "eu-central-1"
}
variable instance_type {
  description = "instance_type"
  # Значение по умолчанию
  default = "t2.micro"
}
variable public_key {
  description = "public_key"
  # Значение по умолчанию
  default = "~/.ssh/appuser.pub"
}
variable privat_key {
  description = "privat_key"
  # Значение по умолчанию
  default = "~/.ssh/appuser"
}
variable sg_ports {
  description = "Allow Ports"
}
variable "vpc_cidr" {
  default = "10.0.0.0/24"
}
