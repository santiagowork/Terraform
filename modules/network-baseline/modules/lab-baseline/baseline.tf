module "baseline" {
  source = "../../"

  name = "${local.common_name}"

  common_tags = merge(
    local.eks_cluster != null ? { "kubernetes.io/role/elb" = "1" } : {},
    local.common_tags,
    var.extra_tags
  )

  aws                = var.aws
  availability_zones = var.baseline.availability_zones
  vpc                = lookup(var.baseline, "vpc", { cidr_block = "172.31.0.0/16" })
  dns                = lookup(var.baseline, "dns", {})

  interface_endpoint_services = concat(
    [
      "ssm",
      "ssmmessages",
      "ec2messages",
      "monitoring",
      "logs"
    ],
    lookup(var.baseline, "extra_interface_endpoint_services", [])
  )

  public_networks = {
    addresses_number        = lookup(var.baseline, "addresses_numbers", 256)
    map_public_ip_on_launch = true

    network_acl_ingress_rules = {
      allow_all = {
        rule_number = 100
        rule_action = "allow"
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    }

    network_acl_egress_rules = {
      allow_all = {
        rule_number = 100
        rule_action = "allow"
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    }
  }
}

module "system_networks" {
  source = "../subnet-layer"

  name = "prv-system-${local.common_name}"

  common_tags = merge(
    local.eks_cluster != null ? { "kubernetes.io/cluster/${local.eks_cluster}" = "shared" } : {},
    local.common_tags
  )

  availability_zones = var.baseline.availability_zones

  vpc = {
    id         = module.baseline.vpc.id
    cidr_block = module.baseline.vpc.cidr_block
  }

  networks = {
    first_network    = local.subnet_start
    addresses_number = lookup(var.baseline, "addresses_numbers", 256)

    route_tables = { for az, prv_rt in module.baseline.private_route_tables :
      az => prv_rt.id
    }
  }

  network_acl_ingress_rules = {
    allow_all = {
      rule_number = 100
      rule_action = "allow"
      protocol    = -1
      cidr_block  = "0.0.0.0/0"
    }
  }

  network_acl_egress_rules = {
    allow_all = {
      rule_number = 100
      rule_action = "allow"
      protocol    = -1
      cidr_block  = "0.0.0.0/0"
    }
  }
}

module "app_networks" {
  source = "../subnet-layer"

  name = "prv-app-${local.common_name}"

  common_tags = merge(
    local.eks_cluster != null ? { "kubernetes.io/cluster/${local.eks_cluster}" = "shared" } : {},
    local.common_tags
  )

  availability_zones = var.baseline.availability_zones

  vpc = {
    id         = module.baseline.vpc.id
    cidr_block = module.baseline.vpc.cidr_block
  }

  networks = {
    first_network    = local.subnet_start * 2
    addresses_number = lookup(var.baseline, "addresses_numbers", 256)

    route_tables = { for az, prv_rt in module.baseline.private_route_tables :
      az => prv_rt.id
    }
  }

  network_acl_ingress_rules = {
    allow_all = {
      rule_number = 100
      rule_action = "allow"
      protocol    = -1
      cidr_block  = "0.0.0.0/0"
    }
  }

  network_acl_egress_rules = {
    allow_all = {
      rule_number = 100
      rule_action = "allow"
      protocol    = -1
      cidr_block  = "0.0.0.0/0"
    }
  }
}

module "data_networks" {
  source = "../subnet-layer"

  name = "prv-data-${local.common_name}"

  common_tags = merge(
    local.common_tags
  )

  availability_zones = var.baseline.availability_zones

  vpc = {
    id         = module.baseline.vpc.id
    cidr_block = module.baseline.vpc.cidr_block
  }

  networks = {
    first_network    = local.subnet_start * 3
    addresses_number = lookup(var.baseline, "addresses_numbers", 256)

    route_tables = { for az, prv_rt in module.baseline.private_route_tables :
      az => prv_rt.id
    }
  }

  network_acl_ingress_rules = {
    allow_all = {
      rule_number = 100
      rule_action = "allow"
      protocol    = -1
      cidr_block  = "0.0.0.0/0"
    }
  }

  network_acl_egress_rules = {
    allow_all = {
      rule_number = 100
      rule_action = "allow"
      protocol    = -1
      cidr_block  = "0.0.0.0/0"
    }
  }
}
