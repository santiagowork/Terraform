locals {
  kms_alias_prefix = lookup(var.kms_alias, "prefix", null) != null ? "${var.kms_alias.prefix}/" : ""
  kms_alias_region = lookup(var.aws, "region", null) != null ? "${var.aws.region}/" : ""
}

resource "aws_kms_alias" "this" {
  count = var.enabled ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  name          = "alias/${local.kms_alias_prefix}${local.kms_alias_region}${var.name}"
  target_key_id = aws_kms_key.this[0].key_id
}
