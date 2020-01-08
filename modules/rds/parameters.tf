resource "aws_db_parameter_group" "this" {
  name        = var.name
  description = "PostgreSQL parameters for ${var.name} RDS"
  family      = var.parameter_group.family

  dynamic "parameter" {
    for_each = [for p in var.parameter_group.parameters : {
      name         = p.name
      value        = p.value
      apply_method = lookup(p, "apply_method", "pending-reboot")
    }]

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}
