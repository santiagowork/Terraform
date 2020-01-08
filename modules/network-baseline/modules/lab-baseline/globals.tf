locals {
  common_name = "${var.project}-${var.environment}"

  common_tags = {
    Environment = var.environment
    Project     = var.project
    Layer       = "networking"
  }

  eks_cluster = lookup(var.baseline, "eks_cluster", null)

  subnet_start = lookup(var.baseline, "subnet_start", 10)

  bastion_security_group = {
    extra_ingress_rules = lookup(lookup(var.bastion, "security_group", {}), "extra_ingress_rules", {})
    extra_egress_rules  = lookup(lookup(var.bastion, "security_group", {}), "extra_egress_rules", {})
  }
}
