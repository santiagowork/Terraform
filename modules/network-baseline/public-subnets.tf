module "public_subnets" {
  source = "./modules/subnet-layer"

  name        = local.public_prefix
  common_tags = var.common_tags

  availability_zones = var.availability_zones

  vpc = {
    id         = aws_vpc.this.id
    cidr_block = var.vpc.cidr_block
  }

  networks = {
    first_network           = lookup(var.public_networks, "first_network", 0)
    addresses_number        = lookup(var.public_networks, "addresses_number", 32)
    map_public_ip_on_launch = lookup(var.public_networks, "map_public_ip_on_launch", false)
    public                  = true

    route_tables = { for az in var.availability_zones :
      az => aws_route_table.public.id
    }
  }

  network_acl_ingress_rules = var.public_networks.network_acl_ingress_rules
  network_acl_egress_rules  = var.public_networks.network_acl_egress_rules
}
