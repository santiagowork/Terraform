module "iam" {
  source = "../iam-role"

  name                 = "codebuild-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  role = merge(
    { description = "Permissions for ${var.name} CodeBuild project" },
    var.iam_role,
    {
      services = ["codebuild"]
    }
  )
}

module "basic_access" {
  source = "../iam-inline-policy"

  name        = "basic-access"
  common_tags = var.common_tags

  policy = {
    role = module.iam.iam_role.name

    statements = [
      {
        sid       = "LogShipping"
        effect    = "Allow"
        resources = ["*"]
        actions = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        sid       = "NetworkRead"
        effect    = "Allow"
        resources = ["*"]
        actions = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
      },
      {
        sid    = "CreateENI"
        effect = "Allow"
        # resources = ["arn:aws:ec2:us-east-1:${var.aws.account_id}:network-interface/*"]
        resources = ["*"]
        actions   = ["ec2:CreateNetworkInterfacePermission"]
        # conditions = [
        #   {
        #     test     = "StringEquals"
        #     variable = "ec2:Subnet",
        #     values   = var.project.vpc_config.subnets
        #   }
        # ]
      },
    ]
  }
}
