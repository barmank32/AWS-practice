# output "external_ip_address_app" {
#   value = yandex_compute_instance.app.*.network_interface.0.nat_ip_address
# }

# output "balancer_ip_address" {
#   value = [for ex_ip in yandex_lb_network_load_balancer.lb-app.listener : ex_ip.external_address_spec].0
# }

output "internal_ip_address" {
  value = aws_network_interface.my_net.private_ip
}
# output "external_ip_address" {
#   value = aws_network_interface.my_net.public_ip
# }
