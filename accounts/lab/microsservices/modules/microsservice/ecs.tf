module "task_definition" {
  source = "../../../../../modules/ecs-task-definition"

  name        = "eai_${var.application}_${var.name}"
  common_tags = var.common_tags
  aws         = var.aws
  log_group   = var.log_group

  task_definition = merge(
    {
      volumes = [for v in var.volumes : {
        name = v.name
      }]

      container_definitions = [{
        name      = "app"
        essential = true
        cpu       = 0
        image     = "${aws_ecr_repository.this.repository_url}:${var.image_version}"

        portMappings = [{
          protocol      = "tcp"
          containerPort = "${var.port}"
          hostPort      = "${var.port}"
        }]

        environment = var.environment
        secrets     = var.secrets
        volumesFrom = []

        mountPoints = [for v in var.volumes : {
          sourceVolume  = v.name
          containerPath = v.mount_point
        }]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = module.task_definition.log_group.name
            awslogs-region        = var.aws.region
            awslogs-stream-prefix = "app"
          }
        }
      }]
    },
    var.task_definition
  )
}

module "service" {
  source = "../../../../../modules/ecs-service"

  name                         = "eai_${var.application}_${var.name}"
  common_tags                  = var.common_tags
  vpc                          = var.vpc
  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules  = var.security_group_egress_rules

  service = merge(
    {
      task_definition = module.task_definition.task_definition.arn
      service_registries = {
        containerPort = var.port
      }
    },
    var.service,
    {
      load_balancers = var.enable_lb_integration ? [{
        target_group_arn = aws_lb_target_group.this.0.arn
        container_name   = "app"
        container_port   = var.port
      }] : []
    }
  )
}
