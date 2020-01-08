output "security_group" {
  value = module.firewall.security_group
}

output "lb" {
  value = aws_lb.this
}

output "https_listener" {
  value = aws_lb_listener.https
}
