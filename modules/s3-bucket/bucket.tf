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

locals {
  name = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name

  bucket = {
    versioning      = lookup(var.bucket, "versioning", { enabled = true })
    logging         = lookup(var.bucket, "logging", null)
    lifecycle_rules = lookup(var.bucket, "lifecycle_rules", [])
  }
}

resource "aws_s3_bucket" "this" {
  lifecycle {
    create_before_destroy = true
  }


  bucket        = local.name
  acl           = "private"
  region        = lookup(var.aws, "region", null)
  policy        = data.aws_iam_policy_document.this.json
  force_destroy = lookup(var.bucket, "force_destroy", false)

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = lookup(var.bucket, "kms_key_arn", null)
        sse_algorithm     = lookup(var.bucket, "sse_algorithm", "aws:kms")
      }
    }
  }

  dynamic "versioning" {
    for_each = local.bucket.versioning != null ? [local.bucket.versioning] : []

    content {
      enabled    = versioning.value.enabled
      mfa_delete = lookup(versioning, "mfa_delete", false)
    }
  }

  dynamic "logging" {
    for_each = local.bucket.logging != null ? [local.bucket.logging] : []

    content {
      target_bucket = versioning.value.target_bucket
      target_prefix = versioning.value.target_prefix
    }
  }

  dynamic "lifecycle_rule" {
    for_each = [for l in local.bucket.lifecycle_rules : {
      id                             = lookup(l, "id", null)
      enabled                        = lookup(l, "enabled", true)
      prefix                         = lookup(l, "prefix", "")
      tags                           = lookup(l, "tags", {})
      transitions                    = lookup(l, "transitions", [])
      noncurrent_version_transitions = lookup(l, "noncurrent_version_transitions", [])
      expiration                     = lookup(l, "expiration", null)
      noncurrent_version_expiration  = lookup(l, "noncurrent_version_expiration", null)
    }]

    content {
      id      = lifecycle_rule.value.id
      enabled = lifecycle_rule.value.enabled
      prefix  = lifecycle_rule.value.prefix
      tags    = lifecycle_rule.value.tags

      dynamic "transition" {
        for_each = [for t in lifecycle_rule.value.transitions : {
          storage_class = lookup(t, "storage_class", null)
          days          = lookup(t, "days", null)
        }]

        content {
          storage_class = transition.value.storage_class
          days          = transition.value.days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = [for t in lifecycle_rule.value.noncurrent_version_transitions : {
          storage_class = lookup(t, "storage_class", null)
          days          = lookup(t, "days", null)
        }]

        content {
          storage_class = noncurrent_version_transition.value.storage_class
          days          = noncurrent_version_transition.value.days
        }
      }

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration != null ? [lifecycle_rule.value.expiration] : []

        content {
          days = expiration.value.days
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = lifecycle_rule.value.noncurrent_version_expiration != null ? [lifecycle_rule.value.noncurrent_version_expiration] : []

        content {
          days = noncurrent_version_expiration.value.days
        }
      }
    }
  }

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
