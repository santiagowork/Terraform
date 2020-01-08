resource "aws_default_vpc_dhcp_options" "this" {
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    map("Name", "DON'T USE: ${var.name} default dhcp option"),
    var.common_tags
  )
}

resource "aws_vpc_dhcp_options" "this" {
  lifecycle {
    create_before_destroy = true
  }

  domain_name          = local.domain_name
  domain_name_servers  = lookup(var.vpc, "domain_name_servers", ["AmazonProvidedDNS"])
  ntp_servers          = lookup(var.vpc, "ntp_servers", null)
  netbios_name_servers = lookup(var.vpc, "netbios_name_servers", null)
  netbios_node_type    = lookup(var.vpc, "netbios_node_type", null)
  tags                 = local.common_tags
}

resource "aws_vpc_dhcp_options_association" "this" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_id          = aws_vpc.this.id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
}
