resource "aws_docdb_cluster_parameter_group" "this" {
  name        = var.name
  description = "MongoDB parameters for ${var.name} DocumentDB database"
  family      = var.parameter_group.family

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )

  dynamic "parameter" {
    for_each = [for k, p in local.parameters : {
      name         = k
      value        = p.value
      apply_method = lookup(p, "apply_method", null)
    }]

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}
