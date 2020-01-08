resource "aws_subnet" "this" {
  for_each = var.availability_zones

  availability_zone       = each.value
  vpc_id                  = var.vpc.id
  cidr_block              = local.cidr_blocks[each.value]
  map_public_ip_on_launch = lookup(var.networks, "map_public_ip_on_launch", false)

  tags = merge(
    map("Name", "${var.name}-${local.az_suffixes[each.value]}"),
    map("Public", local.public),
    var.common_tags
  )
}

resource "aws_route_table_association" "this" {
  for_each = var.availability_zones

  lifecycle {
    create_before_destroy = true
  }

  subnet_id      = aws_subnet.this[each.value].id
  route_table_id = var.networks.route_tables[each.value]
}
