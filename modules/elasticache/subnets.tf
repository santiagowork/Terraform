resource "random_id" "this_subnets" {
  keepers = {
    name = var.name
  }

  byte_length = var.random_suffix_length
}

resource "aws_elasticache_subnet_group" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name        = "${var.name}-${random_id.this_subnets.hex}"
  subnet_ids  = var.elasticache.subnets
  description = "Group to deploy ${var.name} Redis cluster"
}
