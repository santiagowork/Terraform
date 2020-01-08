module "iam" {
  source = "../iam-role"

  name                 = "cloudtrail-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  role = merge(
    { description = "Permissions for ${var.name} trail" },
    var.iam_role,
    { services = ["cloudtrail"] }
  )
}

module "iam_policy_ssm" {
  source = "../iam-inline-policy"

  name                 = "cloudwatch-log-group"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  policy = {
    role = module.iam.iam_role.name

    statements = [
      {
        sid       = "WriteToCloudWatchLogs"
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
