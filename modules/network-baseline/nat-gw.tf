resource "aws_eip" "this" {
  for_each = var.enable_nat_gateways ? var.availability_zones : []

  vpc = true
  tags = merge(
    { Name = "nat-${var.name}-${local.az_suffixes[each.value]}" },
    var.common_tags
  )
}

resource "aws_nat_gateway" "this" {
  for_each = var.enable_nat_gateways ? var.availability_zones : []

  allocation_id = aws_eip.this[each.value].id
  subnet_id     = module.public_subnets.subnets[each.value].id

  tags = merge(
    { Name = "${var.name}-${local.az_suffixes[each.value]}" },
    var.common_tags
  )
}

resource "aws_route" "nat_gateway" {
  for_each = var.enable_nat_gateways ? var.availability_zones : []

  route_table_id         = aws_route_table.privates[each.value].id
  nat_gateway_id         = aws_nat_gateway.this[each.value].id
  destination_cidr_block = "0.0.0.0/0"
}
