resource "random_id" "this_parameter_group" {
  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name    = var.name
    familiy = var.elasticache.family
  }
}

resource "aws_elasticache_parameter_group" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name        = random_id.this_parameter_group.hex
  family      = var.elasticache.family
  description = "Configuration for ${var.name} Redis cluster"

  dynamic "parameter" {
    for_each = [for p in lookup(var.elasticache, "parameteres", []) : {
      name  = p.name
      value = p.value
    }]

    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}
