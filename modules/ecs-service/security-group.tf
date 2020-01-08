module "firewall" {
  source = "../network-baseline/modules/security-group"

  name                 = "ecs-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  security_group = merge(
    { description = "Firewall for ECS task ${var.name}" },
    var.security_group,
    { vpc_id = var.vpc.id }
  )

  ingress_rules = var.security_group_ingress_rules

  egress_rules = merge(
    var.security_group_egress_rules,
    {
      dns = {
        description = "DNS"
        protocol    = "udp"
        from_port   = 53
        to_port     = 53
        cidr_blocks = ["0.0.0.0/0"]
      }

      https = {
        description = "HTTPS"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
      }

      http = {
        description = "HTTP"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  )
}
