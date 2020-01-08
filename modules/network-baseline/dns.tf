resource "aws_route53_zone" "this" {
  count = local.dns_mode == "route53" ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  name          = local.domain_name
  comment       = lookup(var.dns, "description", "Private zone for ${var.name} VPC")
  force_destroy = lookup(var.dns, "zone_force_destroy", false)

  vpc {
    vpc_id = aws_vpc.this.id
  }

  tags = merge(
    map("Name", local.domain_name),
    var.common_tags
  )
}

resource "aws_route53_zone_association" "this" {
  count = local.dns_mode == "external_route53" ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  zone_id = lookup(var.dns, "zone_id", null)
  vpc_id  = aws_vpc.this.id
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  count = local.dns_mode == "cloud_map" ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  name        = local.domain_name
  description = lookup(var.dns, "description", "DNS auto discovery service for ${var.name} VPC")
  vpc         = aws_vpc.this.id
}
