output "internal_ip_address_app" {
  value = aws_instance.app.private_ip
}
output "internal_ip_address_db" {
  value = aws_instance.db.private_ip
}
# output "external_ip_address_app" {
#   value = aws_eip.eip_app.public_ip
# }
# output "external_ip_address_db" {
#   value = aws_eip.eip_db.public_ip
# }
output "external_ip_address_bastion" {
  value = aws_instance.bastion.public_ip
}


output "NAT_IP_GW" {
  value = aws_nat_gateway.aws_nat_gateway.public_ip
}

output "subnet_id" {
  value = aws_subnet.mysub[*].id
}
output "subnet_cidr" {
  value = aws_subnet.mysub[*].cidr_block
}
