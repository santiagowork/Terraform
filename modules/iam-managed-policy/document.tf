data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = [for ks in var.policy.statements : {
      sid            = lookup(ks, "sid", null)
      effect         = lookup(ks, "effect", null)
      actions        = lookup(ks, "actions", null)
      not_actions    = lookup(ks, "not_actions", null)
      resources      = lookup(ks, "resources", null)
      not_resources  = lookup(ks, "not_resources", null)
      principals     = lookup(ks, "principals", [])
      not_principals = lookup(ks, "not_principals", [])
      conditions     = lookup(ks, "conditions", [])
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
