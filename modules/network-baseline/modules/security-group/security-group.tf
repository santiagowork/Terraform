resource "random_id" "this" {
  count = var.random_suffix_length > 0 ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name        = var.name
    description = var.security_group.description
  }
}

resource "aws_security_group" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name                   = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name
  vpc_id                 = var.security_group.vpc_id
  description            = var.random_suffix_length > 0 ? random_id.this.0.keepers.description : var.security_group.description
  revoke_rules_on_delete = lookup(var.security_group, "revoke_rules_on_delete", false)

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
