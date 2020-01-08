module "iam" {
  source = "../iam-role"

  name                 = "event-${var.name}-debug"
  common_tags          = var.common_tags
  random_suffix_length = var.random_suffix_length

  role = {
    description = "Permissions for event rule to use cloudwatch log group as a target"
    services    = ["events"]
  }
}

module "save_log_permission" {
  source = "../iam-inline-policy"

  name                 = "log-saver"
  common_tags          = var.common_tags
  random_suffix_length = var.random_suffix_length

  policy = {
    role = module.iam.iam_role.name

    statements = [
      {
        sid       = "LogSaving"
        effect    = "Allow"
        resources = [module.log.log_group.arn]

        actions = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
      }
    ]
  }
}
