resource "aws_cloudwatch_log_group" "this" {
  count = var.enabled ? 1 : 0

  name              = var.name
  kms_key_id        = var.log_group.kms_key_arn
  retention_in_days = lookup(var.log_group, "retention_in_days", 90)

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
