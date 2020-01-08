resource "aws_cloudwatch_event_rule" "this" {
  name        = "${var.name}-debug"
  description = "Capture all ${var.name} events for debbuging"
  is_enabled  = true
  role_arn    = module.iam.iam_role.arn

  event_pattern = templatefile(
    "${path.module}/data/debug-events.json",
    { service = var.name }
  )

  tags = merge(
    var.common_tags,
    { Name = "${var.name}-debug" }
  )
}

resource "aws_cloudwatch_event_target" "this" {
  target_id = "save-events"
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = module.log.log_group.arn
}
