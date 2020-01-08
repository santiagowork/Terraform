locals {
  cloudwatch_logs_statement = lookup(var.kms_key, "enable_cloudwatch_logs_support", false) ? [
    {
      sid       = "EncryptDecryptLogs"
      effect    = "Allow"
      resources = ["*"]

      actions = [
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Encrypt*",
        "kms:Describe*",
        "kms:Decrypt*",
      ]

      principals = [{
        type        = "Service"
        identifiers = ["logs.${var.aws.region}.amazonaws.com"]
      }]
    }
  ] : []

  cloudtrail_statement = lookup(var.kms_key, "enable_cloudtrail_support", false) ? [
    {
      sid       = "CloudTrailKeyGeneration"
      effect    = "Allow"
      actions   = ["kms:GenerateDataKey*"]
      resources = ["*"]

      principals = [{
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }]

      condition = [{
        test     = "StringLike"
        variable = "kms:EncryptionContext:aws:cloudtrail:arn"
        values   = ["arn:aws:cloudtrail:*:${var.aws.account_id}:trail/*"]
      }]
    }
  ] : []

  statements = concat(
    local.cloudwatch_logs_statement,
    local.cloudtrail_statement
  )
}

data "aws_iam_policy_document" "default" {
  count = var.enabled ? 1 : 0

  override_json = lookup(var.kms_key, "custom_policy", null)

  statement {
    sid       = ""
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws.account_id}:root"]
    }
  }

  dynamic "statement" {
    for_each = [for s in local.statements : {
      sid            = lookup(s, "sid", null)
      effect         = lookup(s, "effect", null)
      actions        = lookup(s, "actions", null)
      not_actions    = lookup(s, "not_actions", null)
      resources      = lookup(s, "resources", null)
      not_resources  = lookup(s, "not_resources", null)
      principals     = lookup(s, "principals", [])
      not_principals = lookup(s, "not_principals", [])
      conditions     = lookup(s, "conditions", [])
    }]

    content {
      sid           = statement.value.sid
      effect        = statement.value.effect
      actions       = statement.value.actions
      not_actions   = statement.value.not_actions
      resources     = statement.value.resources
      not_resources = statement.value.not_resources

      dynamic "principals" {
        for_each = [for p in statement.value.principals : {
          type        = lookup(p, "type", null)
          identifiers = lookup(p, "identifiers", null)
        }]

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = [for np in statement.value.not_principals : {
          type        = lookup(np, "type", null)
          identifiers = lookup(np, "identifiers", null)
        }]

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = [for c in statement.value.conditions : {
          test     = lookup(c, "test", null)
          variable = lookup(c, "variable", null)
          values   = lookup(c, "values", null)
        }]

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_kms_key" "this" {
  count = var.enabled ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  description             = var.kms_key.description
  is_enabled              = lookup(var.kms_key, "is_enabled", true)
  key_usage               = lookup(var.kms_key, "key_usage", "ENCRYPT_DECRYPT")
  deletion_window_in_days = lookup(var.kms_key, "deletion_window_in_days", 30)
  enable_key_rotation     = lookup(var.kms_key, "enable_key_rotation", true)
  policy                  = data.aws_iam_policy_document.default[0].json

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
