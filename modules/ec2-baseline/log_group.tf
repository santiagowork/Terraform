module "logs" {
  source = "../cloudwatch-log-group"

  name        = "/ec2/${var.name}"
  common_tags = var.common_tags

  log_group = merge(
    var.log_group,
    { enabled = lookup(var.iam_role, "enable_cloudwatch_log", true) }
  )
}
