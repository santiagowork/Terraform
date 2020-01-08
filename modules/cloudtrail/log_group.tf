module "logs" {
  source = "../cloudwatch-log-group"

  name        = "/cloudtrail/${var.name}"
  common_tags = var.common_tags

  log_group = merge(
    var.log_group,
    { kms_key_arn = var.trail.kms_key_arn }
  )
}
