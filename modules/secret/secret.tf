resource "random_id" "this" {
  count = var.random_suffix_length > 0 ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name = var.name
  }
}

resource "aws_secretsmanager_secret" "this" {
  name                    = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name
  description             = var.secret.description
  kms_key_id              = module.encryption.kms_key.arn
  recovery_window_in_days = lookup(var.secret, "recovery_window_in_days", 30)

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
