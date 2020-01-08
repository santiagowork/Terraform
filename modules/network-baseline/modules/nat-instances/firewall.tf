locals {
  internet_access_egress = [for r in local.security_group.allowed_traffic_to_internet_rules : {
    description = lookup(r, "description", "Managed by cloud-blueprints/aws-nat-instances module")
    protocol    = lookup(r, "protocol", null)
    from_port   = lookup(r, "from_port", null)
    to_port     = lookup(r, "to_port", null)
    cidr_blocks = lookup(r, "cidr_blocks", ["0.0.0.0/0"])
  }]

  nat_ingress_rules = { for r in local.security_group.allowed_traffic_to_internet_rules :
    r.key => {
      description              = lookup(r.value, "description", "Managed by cloud-blueprints/aws-nat-instances module")
      source_security_group_id = module.internet_access.security_group.id
      protocol                 = lookup(r.value, "protocol", null)
      from_port                = lookup(r.value, "from_port", null)
      to_port                  = lookup(r.value, "to_port", null)
    }
  }
}

module "internet_access" {
  source = "../network-baseline/modules/security-group"

  name                 = "ec2-internet-access-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = local.common_tags

  security_group = {
    description  = "Allow access to Internet via NAT instances"
    vpc_id       = local.vpc.id
    egress_rules = local.internet_access_egress
  }
}
