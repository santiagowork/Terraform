# resource "aws_cloudwatch_event_rule" "launch_success" {
#   name          = "autoscaling-launch-instance-${var.name}"
#   description   = "Capture new instances launched by the ${var.name} Autoscaling Group and execute SSM tasks on it"
#   event_pattern = templatefile("${path.module}/data/event-launch-success.json", { asg_name = aws_autoscaling_group.this.name })
#   is_enabled    = true
# }
