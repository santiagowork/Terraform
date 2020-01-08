module "endpoint_access" {
  source = "./modules/security-group"

  name                 = "vpc-endpoints-access-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  security_group = {
    description = "Access for interface based VPC endpoint on ${var.name}"
    vpc_id      = aws_vpc.this.id
  }

  egress_rules = {
    endpoints_access = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

module "endpoint_firewall" {
  source = "./modules/security-group"

  name                 = "vpc-endpoints-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  security_group = {
    description = "Firewall for interface based VPC endpoint on ${var.name}"
    vpc_id      = aws_vpc.this.id
  }

  ingress_rules = {
    endpoints_access = {
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.endpoint_access.security_group.id
    }
  }
}

resource "aws_vpc_endpoint" "interface_based" {
  for_each = var.interface_endpoint_services

  service_name        = "com.amazonaws.${var.aws.region}.${each.value}"
  auto_accept         = true
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.this.id
  subnet_ids          = values(module.public_subnets.subnets).*.id
  security_group_ids  = [module.endpoint_firewall.security_group.id]

  tags = merge(
    map("Name", "${each.value}-${var.name}"),
    var.common_tags
  )
}

resource "aws_vpc_endpoint" "route_based" {
  for_each = { for srv, endpoint in var.route_endpoint_services :
    srv => {
      policy = lookup(endpoint, "policy", null)
    }
  }

  service_name      = "com.amazonaws.${var.aws.region}.${each.key}"
  auto_accept       = true
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.this.id
  policy            = each.value.policy

  tags = merge(
    map("Name", "${each.key}-${var.name}"),
    var.common_tags
  )
}

resource "aws_vpc_endpoint_route_table_association" "route_based_endpoint_public" {
  for_each = aws_vpc_endpoint.route_based

  vpc_endpoint_id = each.value.id
  route_table_id  = aws_route_table.public.id
}


resource "aws_vpc_endpoint_route_table_association" "route_based_endpoint_privates" {
  for_each = zipmap(
    flatten([for srv, e in aws_vpc_endpoint.route_based : [
      for az, rt in aws_route_table.privates :
      "${srv}-${az}"
    ]]),
    flatten([for srv, e in aws_vpc_endpoint.route_based : [
      for az, rt in aws_route_table.privates : {
        endpoint_id    = e.id
        route_table_id = rt.id
      }
    ]])
  )

  vpc_endpoint_id = each.value.endpoint_id
  route_table_id  = each.value.route_table_id
}
