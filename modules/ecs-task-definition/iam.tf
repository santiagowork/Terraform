module "iam_task_execution" {
  source = "../iam-role"

  name                 = "ecs-task-execution-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  role = merge(
    { description = "Permissions for ECS/Fargate execute task ${var.name}" },
    var.iam_role_task_execution,
    {
      type     = "service"
      services = ["ecs-tasks"]
    }
  )
}

module "iam_policy_task_execution_ecr" {
  source = "../iam-inline-policy"

  name                 = "ecr"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  policy = {
    role = module.iam_task_execution.iam_role.name

    statements = [
      {
        sid       = "EcrAccess"
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
      }
    ]
  }
}

module "iam_policy_task_execution_logs" {
  source = "../iam-inline-policy"

  name                 = "logs"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  policy = {
    role = module.iam_task_execution.iam_role.name

    statements = [
      {
        sid       = "Logging"
        effect    = "Allow"
        resources = [module.logs.log_group.arn]

        actions = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      }
    ]
  }
}

module "iam_task" {
  source = "../iam-role"

  name                 = "ecs-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  role = merge(
    { description = "Permissions for ${var.name} ECS task on AWS" },
    var.iam_role,
    {
      type     = "service"
      services = ["ecs-tasks"]
    }
  )
}
