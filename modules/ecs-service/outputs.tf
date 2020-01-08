output "security_group" {
  value = module.firewall.security_group
}

output "ecs_service" {
  value = aws_ecs_service.this
}
