locals {
  cpu    = lookup(var.task_definition, "cpu", 256)
  memory = lookup(var.task_definition, "memory", 512)
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  requires_compatibilities = lookup(var.task_definition, "requires_compatibilities", ["FARGATE"])
  network_mode             = lookup(var.task_definition, "network_mode", "awsvpc")
  cpu                      = local.cpu
  memory                   = local.memory
  execution_role_arn       = module.iam_task_execution.iam_role.arn
  task_role_arn            = module.iam_task.iam_role.arn
  container_definitions    = jsonencode(var.task_definition.container_definitions)

  dynamic "volume" {
    for_each = [for v in lookup(var.task_definition, "volumes", []) : {
      name = lookup(v, "name", null)
    }]

    content {
      name = volume.value.name
    }
  }

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
