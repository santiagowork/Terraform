# module "iam_autoscaling" {
#   source = "../iam-role"
#
#   name                 = "autoscaling-ecs-${var.name}"
#   random_suffix_length = var.random_suffix_length
#   common_tags          = var.common_tags
#
#   role = {
#     type        = "service"
#     description = "Permissions for autoscale to handle ECS task ${var.name}"
#     services    = ["application-autoscaling"]
#   }
# }
#
# module "iam_policy_autoscaling" {
#   source = "../iam-inline-policy"
#
#   name                 = "ecs"
#   random_suffix_length = var.random_suffix_length
#   common_tags          = var.common_tags
#
#   policy = {
#     role = module.iam_task_execution.iam_role.name
#
#     statements = [
#       {
#         sid       = "ChangeServiceDesiredTasks"
#         effect    = "Allow"
#         resources = [aws_ecs_service.this.arn]
#
#         actions = [
#           "ecs:"
#         ]
#       }
#     ]
#   }
# }

resource "aws_appautoscaling_target" "this" {
  lifecycle {
    create_before_destroy = true
  }

  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.service.min_capacity
  max_capacity       = var.service.max_capacity
  resource_id        = "service/${var.service.cluster_name}/${aws_ecs_service.this.name}"
}

# resource "random_id" "target_tracking" {
#   lifecycle {
#     create_before_destroy = true
#   }
#
#   for_each = var.target_tracking_policies
#
#   prefix      = "${each.key}-"
#   byte_length = var.random_suffix_length / 2
#
#   keepers = {
#     name = aws_ecs_service.this.name
#   }
# }
#
# resource "aws_appautoscaling_policy" "target_tracking" {
#   lifecycle {
#     create_before_destroy = true
#   }
#
#   for_each = var.target_tracking_policies
#
#   name               = random_id.target_tracking[each.key].name
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.this.resource_id
#   scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this.service_namespace
#
#   dynamic "target_tracking_scaling_policy_configuration" {
#     for_each = [for ttp in each.value.scaling_policy_configurations : {
#       target_value                    = ttp.target_value
#       scale_in_cooldown               = lookup(ttp, "scale_in_cooldown", 300)
#       scale_out_cooldown              = lookup(ttp, "scale_out_cooldown", 300)
#       disable_scale_in                = lookup(ttp, "disable_scale_in", false)
#       predefined_metric_specification = ttp.predefined_metric_specification
#     }]
#
#     content {
#       target_value       = target_tracking_scaling_policy_configuration.value.target_value
#       scale_in_cooldown  = target_tracking_scaling_policy_configuration.value.scale_in_cooldown
#       scale_out_cooldown = target_tracking_scaling_policy_configuration.value.scale_out_cooldown
#       disable_scale_in   = target_tracking_scaling_policy_configuration.value.disable_scale_in
#
#       dynamic "predefined_metric_specification" {
#         for_each = [target_tracking_scaling_policy_configuration.value.predefined_metric_specification]
#
#         content {
#           predefined_metric_type = predefined_metric_specification.value.predefined_metric_type
#         }
#       }
#     }
#   }
# }
