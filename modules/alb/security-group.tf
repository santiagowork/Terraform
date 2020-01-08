module "firewall" {
  source = "../network-baseline/modules/security-group"

  name                 = "alb-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  security_group = merge(
    { description = "Firewall for ALB ${var.name}" },
    var.security_group,
    { vpc_id = var.vpc.id }
  )

  ingress_rules = var.security_group_ingress_rules
  egress_rules  = var.security_group_egress_rules
}
