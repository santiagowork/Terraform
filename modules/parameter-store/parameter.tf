resource "aws_ssm_parameter" "this" {
  lifecycle {
    ignore_changes = [value]
  }

  name            = var.name
  description     = var.parameter.description
  type            = "SecureString"
  overwrite       = true
  value           = "change me"
  key_id          = var.parameter.kms_key_id
  tier            = lookup(var.parameter, "tier", "Standard")
  allowed_pattern = lookup(var.parameter, "allowed_pattern", null)

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )
}
