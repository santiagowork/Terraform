resource "aws_vpc" "this" {
  lifecycle {
    create_before_destroy = true
  }

  cidr_block                       = var.vpc.cidr_block
  instance_tenancy                 = lookup(var.vpc, "instance_tenance", "default")
  enable_dns_support               = true
  enable_dns_hostnames             = true
  enable_classiclink               = lookup(var.vpc, "enable_classiclink", false)
  enable_classiclink_dns_support   = lookup(var.vpc, "enable_classiclink_dns_support", false)
  assign_generated_ipv6_cidr_block = lookup(var.vpc, "assign_generated_ipv6_cidr_block", false)
  tags                             = local.common_tags
}
