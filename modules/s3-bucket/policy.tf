locals {
  bucket_arn = "arn:aws:s3:::${local.name}"

  // If KMS was choosed, deny different key uploads
  bucket_kms_statements = lookup(var.bucket, "sse_algorithm", "aws:kms") == "aws:kms" ? [{
    sid       = ""
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${local.bucket_arn}/*"]

    principals = [{
      type        = "*"
      identifiers = ["*"]
    }]

    conditions = [{
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [var.bucket.kms_key_arn]
    }]
  }] : []
}

data "aws_iam_policy_document" "this" {
  override_json = lookup(var.bucket, "custom_policy", null)

  statement {
    sid       = ""
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [local.bucket_arn]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws.account_id}:root"]
    }
  }

  // disallow not encrypted uploads
  statement {
    sid     = ""
    effect  = "Deny"
    actions = ["s3:PutObject"]

    resources = ["${local.bucket_arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["true"]
    }
  }

  // disallow uploads differents from SSE option
  statement {
    sid       = ""
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${local.bucket_arn}/*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = [lookup(var.bucket, "sse_algorithm", "aws:kms")]
    }
  }

  # dynamic "statement" {
  #   for_each = [for ks in local.bucket_kms_statements : {
  #     sid            = lookup(ks, "sid", null)
  #     effect         = lookup(ks, "effect", null)
  #     actions        = lookup(ks, "actions", null)
  #     not_actions    = lookup(ks, "not_actions", null)
  #     resources      = lookup(ks, "resources", null)
  #     not_resources  = lookup(ks, "not_resources", null)
  #     principals     = lookup(ks, "principals", [])
  #     not_principals = lookup(ks, "not_principals", [])
  #     conditions     = lookup(ks, "conditions", [])
  #   }]
  #
  #   content {
  #     sid           = statement.value.sid
  #     effect        = statement.value.effect
  #     actions       = statement.value.actions
  #     not_actions   = statement.value.not_actions
  #     resources     = statement.value.resources
  #     not_resources = statement.value.not_resources
  #
  #     dynamic "principals" {
  #       for_each = [for p in statement.value.principals : {
  #         type        = lookup(p, "type", null)
  #         identifiers = lookup(p, "identifiers", null)
  #       }]
  #
  #       content {
  #         type        = principals.value.type
  #         identifiers = principals.value.identifiers
  #       }
  #     }
  #
  #     dynamic "not_principals" {
  #       for_each = [for np in statement.value.not_principals : {
  #         type        = lookup(np, "type", null)
  #         identifiers = lookup(np, "identifiers", null)
  #       }]
  #
  #       content {
  #         type        = not_principals.value.type
  #         identifiers = not_principals.value.identifiers
  #       }
  #     }
  #
  #     dynamic "condition" {
  #       for_each = [for c in statement.value.conditions : {
  #         test     = lookup(c, "test", null)
  #         variable = lookup(c, "variable", null)
  #         values   = lookup(c, "values", null)
  #       }]
  #
  #       content {
  #         test     = condition.value.test
  #         variable = condition.value.variable
  #         values   = condition.value.values
  #       }
  #     }
  #   }
  # }
}
