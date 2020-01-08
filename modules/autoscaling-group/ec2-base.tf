module "ec2_base" {
  source = "../ec2-baseline"

  name                 = var.name
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags
  vpc                  = var.vpc

  iam_role = merge(
    { description = "AWS permissions for ${var.name} Autoscaling Group instances" },
    var.iam_role
  )

  security_group = merge(
    { description = "Firewall for ${var.name} Autoscaling Group instances" },
    var.security_group
  )

  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules  = var.security_group_egress_rules

  log_group = var.log_group
}
