output "public_lb_dns" {
  value = module.load_balancer.public_lb_dns
}

output "private_lb_dns" {
  value = module.load_balancer.private_lb_dns
}