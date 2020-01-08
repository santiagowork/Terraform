resource "random_id" "this" {
  count = var.random_suffix_length > 0 ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name = var.name
  }
}

resource "aws_autoscaling_group" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name                      = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name
  min_size                  = var.autoscaling_group.min_size
  max_size                  = var.autoscaling_group.max_size
  vpc_zone_identifier       = var.autoscaling_group.vpc_zone_identifier
  force_delete              = lookup(var.autoscaling_group, "force_delete", true)
  protect_from_scale_in     = lookup(var.autoscaling_group, "protect_from_scale_in", false)
  default_cooldown          = lookup(var.autoscaling_group, "default_cooldown", 300)
  health_check_grace_period = lookup(var.autoscaling_group, "health_check_grace_period", 300)
  health_check_type         = lookup(var.autoscaling_group, "health_check_type", "EC2")
  load_balancers            = lookup(var.autoscaling_group, "load_balancers", [])
  target_group_arns         = lookup(var.autoscaling_group, "target_group_arns", [])
  metrics_granularity       = "1Minute"
  suspended_processes       = lookup(var.autoscaling_group, "suspended_processes", [])
  placement_group           = lookup(var.autoscaling_group, "placement_group", null)
  wait_for_capacity_timeout = lookup(var.autoscaling_group, "wait_for_capacity_timeout", 0)
  wait_for_elb_capacity     = lookup(var.autoscaling_group, "wait_for_elb_capacity", null)
  min_elb_capacity          = lookup(var.autoscaling_group, "min_elb_capacity", null)

  termination_policies = lookup(var.autoscaling_group, "termination_policies", [
    "OldestLaunchTemplate",
    "OldestInstance",
    "Default"
  ])

  enabled_metrics = lookup(var.autoscaling_group, "enabled_metrics", [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ])

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = var.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = false
    }
  }
}
