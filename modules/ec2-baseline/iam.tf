module "iam" {
  source = "../iam-role"

  name                 = "ec2-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  role = merge(
    { description = "Permissions for ${var.name} EC2 instances" },
    var.iam_role,
    {
      services = [
        "ec2",
        "ssm"
      ]
    }
  )
}

module "iam_policy_ssm" {
  source = "../iam-inline-policy"

  name                 = "ssm"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  policy = {
    enabled = lookup(var.iam_role, "ssm_enabled", true)
    role    = module.iam.iam_role.name

    statements = [
      {
        sid       = "SsmBaseline"
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "ssm:UpdateInstanceInformation",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ssm:UpdateInstanceAssociationStatus",
          "ssm:GetDocument",
          "ssm:PutInventory",
          "ssmmessages:*",
          "ec2messages:*"
        ]
      }
    ]
  }
}

module "iam_policy_put_metrics" {
  source = "../iam-inline-policy"

  name                 = "put-metrics"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  policy = {
    enabled = lookup(var.iam_role, "put_metrics_enabled", true)
    role    = module.iam.iam_role.name

    statements = [
      {
        sid       = "PutMetrics"
        effect    = "Allow"
        actions   = ["cloudwatch:PutMetricData"]
        resources = ["*"]
      }
    ]
  }
}

module "iam_policy_log_shipping" {
  source = "../iam-inline-policy"

  name                 = "log-shipping"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  policy = {
    enabled = lookup(var.iam_role, "enable_cloudwatch_log", true)
    role    = module.iam.iam_role.name

    statements = [
      {
        sid       = "LogShipping"
        effect    = "Allow"
        resources = [module.logs.log_group.arn]

        actions = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
      }
    ]
  }
}
