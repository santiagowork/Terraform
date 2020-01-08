resource "random_id" "this" {
  count = var.random_suffix_length > 0 ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name = var.name
    # port = join(",", var.service.load_balancers.*.container_port)
  }
}

resource "aws_ecs_service" "this" {
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_count]
  }

  name                              = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name
  cluster                           = var.service.cluster_arn
  task_definition                   = var.service.task_definition
  launch_type                       = lookup(var.service, "launch_type", "FARGATE")
  scheduling_strategy               = lookup(var.service, "scheduling_strategy", "REPLICA")
  health_check_grace_period_seconds = lookup(var.service, "health_check_grace_period_seconds", 0)
  platform_version                  = lookup(var.service, "platform_version", "1.3.0")
  desired_count                     = 0
  propagate_tags                    = "SERVICE"

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )

  dynamic "load_balancer" {
    for_each = [for lb in lookup(var.service, "load_balancers", []) : {
      target_group_arn = lb.target_group_arn
      container_name   = lb.container_name
      container_port   = lb.container_port
      }
    ]

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.this.arn
  #   container_name   = "app"
  #   container_port   = 8080
  # }

  # Needs change account as root (really AWS????)
  # https://aws.amazon.com/blogs/compute/migrating-your-amazon-ecs-deployment-to-the-new-arn-and-resource-id-format-2/
  # enable_ecs_managed_tags = true
  enable_ecs_managed_tags = false
  # propagate_tags          = lookup(var.service, "propagate_tags", "SERVICE")
  #
  # tags = merge(
  #   var.common_tags,
  #   { Name = var.name }
  # )

  # dynamic "ordered_placement_strategy" {
  #   for_each = [for ops in [lookup(var.service, "ordered_placement_strategy", [{
  #     type  = "spread"
  #     field = "instanceId"
  #     }])] : {
  #     type  = lookup(ops, "type", null)
  #     field = lookup(ops, "field", null)
  #   }]
  #
  #   content {
  #     type  = ordered_placement_strategy.value.type
  #     field = ordered_placement_strategy.value.field
  #   }
  # }

  dynamic "service_registries" {
    for_each = [for sr in [var.service.service_registries] : {
      registry_arn   = aws_service_discovery_service.this.arn
      port           = lookup(sr, "port", 0)
      container_name = lookup(sr, "container_name", null)
      container_port = lookup(sr, "container_port", 0)
    }]

    content {
      registry_arn   = service_registries.value.registry_arn
      container_name = service_registries.value.container_name
      port           = service_registries.value.port
      container_port = service_registries.value.container_port
    }
  }

  dynamic "deployment_controller" {
    for_each = [for dc in [lookup(var.service, "deployment_controller", { type = "ECS" })] : {
      type = dc.type
    }]

    content {
      type = deployment_controller.value.type
    }
  }

  dynamic "network_configuration" {
    for_each = [for nc in [var.service.network_configuration] : {
      subnets          = nc.subnets
      assign_public_ip = lookup(nc, "assign_public_ip", false)

      security_groups = concat(
        [module.firewall.security_group.id],
        lookup(nc, "extra_security_group_ids", [])
      )
    }]

    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }
}
