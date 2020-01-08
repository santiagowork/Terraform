module "microsservice" {
  source = "../../modules/microsservice"

  application = "login"
  name        = "test"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  git = {
    description = "test repository"
  }

  log_group = {
    kms_key_arn       = data.aws_kms_key.logging.arn
    retention_in_days = 7
  }

  volumes = [{
    name        = "tmp"
    mount_point = "/var/tmp/nginx"
  }]

  port = local.port

  enable_lb_integration = true

  lb_integration = {
    listener_arn         = data.aws_lb_listener.public_https.arn
    priority             = 100
    deregistration_delay = 15

    health_check = {
      path                = "/health-check"
      interval            = 10
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }

    conditions = [{
      field  = "path-pattern"
      values = ["/login/test"]
    }]
  }

  image_version = "0.0.3"

  security_group_ingress_rules = {
    lb_http = {
      protocol                 = "tcp"
      from_port                = local.port
      to_port                  = local.port
      source_security_group_id = data.aws_security_group.public_lb.id
    }
  }

  security_group_egress_rules = {
    all_traffic = {
      protocol    = "all"
      from_port   = -1
      to_port     = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  service = {
    cluster_name = data.aws_ecs_cluster.this.cluster_name
    cluster_arn  = data.aws_ecs_cluster.this.arn

    namespace_id = data.external.namespace.result.id
    min_capacity = 0
    max_capacity = 3

    network_configuration = {
      subnets                  = data.aws_subnet_ids.app.ids
      extra_security_group_ids = [data.aws_security_group.endpoint_access.id]
    }
  }
}
