resource "random_id" "public_target_group" {
  count = var.enable_lb_integration ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = lookup(var.lb_integration, "target_group_name", null) == null ? "${var.application}-${var.name}-" : "${var.lb_integration.target_group_name}-"
  byte_length = 2

  keepers = {
    name = var.name
    port = var.port
  }
}

resource "aws_lb_target_group" "this" {
  count = var.enable_lb_integration ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  name                 = random_id.public_target_group.0.hex
  target_type          = "ip"
  vpc_id               = var.vpc.id
  protocol             = lookup(var.lb_integration, "protocol", "HTTP")
  port                 = var.port
  deregistration_delay = var.lb_integration.deregistration_delay
  slow_start           = lookup(var.lb_integration, "slow_start", 0)

  health_check {
    enabled             = lookup(var.lb_integration.health_check, "enabled", true)
    protocol            = lookup(var.lb_integration.health_check, "protocol", "HTTP")
    port                = var.port
    path                = var.lb_integration.health_check.path
    interval            = var.lb_integration.health_check.interval
    healthy_threshold   = var.lb_integration.health_check.healthy_threshold
    unhealthy_threshold = var.lb_integration.health_check.unhealthy_threshold
    matcher             = lookup(var.lb_integration.health_check, "matcher", "200")
  }

  tags = merge(
    var.common_tags,
    { Name = "pub-${var.application}-${var.name}" }
  )
}

resource "aws_lb_listener_rule" "this" {
  count = var.enable_lb_integration ? 1 : 0

  listener_arn = var.lb_integration.listener_arn
  priority     = var.lb_integration.priority

  dynamic "condition" {
    for_each = [for c in var.lb_integration.conditions : {
      field  = c.field
      values = c.values
    }]

    content {
      field  = condition.value.field
      values = condition.value.values
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.0.arn
  }
}
