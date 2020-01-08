resource "aws_default_route_table" "this" {
  lifecycle {
    create_before_destroy = true
  }

  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    map("Name", "DON'T USE: ${var.name} blocked default route table"),
    var.common_tags
  )
}

resource "aws_internet_gateway" "this" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_id = aws_vpc.this.id
  tags   = local.common_tags
}

resource "aws_route_table" "public" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_id = aws_vpc.this.id
  tags = merge(
    map("Name", local.public_prefix),
    var.common_tags
  )
}

resource "aws_route" "public_default_route" {
  lifecycle {
    create_before_destroy = true
  }

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table" "privates" {
  for_each = var.availability_zones

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = aws_vpc.this.id
  tags = merge(
    map("Name", "${local.private_prefix}-${local.az_suffixes[each.value]}"),
    var.common_tags
  )
}
