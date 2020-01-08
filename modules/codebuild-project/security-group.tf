module "firewall" {
  source = "../network-baseline/modules/security-group"

  name                 = "codebuild-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  security_group = merge(
    var.security_group,
    { vpc_id = var.vpc.id }
  )

  ingress_rules = var.security_group_ingress_rules

  egress_rules = merge(
    var.security_group_egress_rules,
    {
      dns = {
        protocol    = "udp"
        from_port   = 53
        to_port     = 53
        cidr_blocks = ["0.0.0.0/0"]
      }

      https = {
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  )
}
