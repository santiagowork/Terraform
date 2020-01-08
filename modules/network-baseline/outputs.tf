output "vpc" {
  value = aws_vpc.this
}

output "route53_zone" {
  value = aws_route53_zone.this
}

output "dhcp_options" {
  value = aws_vpc_dhcp_options.this
}

output "internet_gateway" {
  value = aws_internet_gateway.this
}

output "public_route_table" {
  value = aws_route_table.public
}

output "private_route_tables" {
  value = aws_route_table.privates
}

output "public_subnets" {
  value = module.public_subnets.subnets
}

output "public_subnets_network_acl" {
  value = module.public_subnets.network_acl
}

output "endpoint_access_security_group" {
  value = module.endpoint_access.security_group
}

output "nat_gateways" {
  value = aws_nat_gateway.this
}

output "service_discovery_dns_namespace" {
  value = aws_service_discovery_private_dns_namespace.this
}
