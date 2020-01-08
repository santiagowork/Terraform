module "baseline" {
  source             = "../../../modules/network-baseline"
  name               = local.name
  common_tags        = local.common_tags
  aws                = local.aws
  availability_zones = local.availability_zones
  dns                = local.dns
  # interface_endpoint_services = []
  vpc                 = local.vpc
  public_networks     = local.public_networks
  enable_nat_gateways = true
}

module "system_networks" {
  source = "../../../modules/network-baseline/modules/subnet-layer"

  name               = "prv-system-${local.name}"
  common_tags        = local.common_tags
  availability_zones = local.availability_zones

  vpc = {
    id         = module.baseline.vpc.id
    cidr_block = "172.29.4.0/22"
  }

  networks = {
    first_network    = 0
    addresses_number = 256

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
  source = "../../../modules/network-baseline/modules/subnet-layer"

  name               = "prv-app-${local.name}"
  common_tags        = local.common_tags
  availability_zones = local.availability_zones

  vpc = {
    id         = module.baseline.vpc.id
    cidr_block = "172.29.8.0/22"
  }

  networks = {
    first_network    = 0
    addresses_number = 256

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
  source = "../../../modules/network-baseline/modules/subnet-layer"

  name               = "prv-data-${local.name}"
  common_tags        = local.common_tags
  availability_zones = local.availability_zones

  vpc = {
    id         = module.baseline.vpc.id
    cidr_block = "172.29.12.0/22"
  }

  networks = {
    first_network    = 0
    addresses_number = 256

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
