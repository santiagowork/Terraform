module "microsservice" {
  source = "../../modules/microsservice"

  application = "login"
  name        = "autorization-code-exchange"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  git = {
    description = "Orquestrador para troca de code pelo token"
  }

  log_group = {
    kms_key_arn       = data.aws_kms_key.logging.arn
    retention_in_days = 7
  }

  volumes = [{
    name        = "tmp"
    mount_point = "/tmp"
  }]

  image_version = "0.2.0"

  port = local.port
 
  secrets = [
    {
      name      = "AUTHORIZE_HOST"
      valueFrom = data.aws_ssm_parameter.authorize_host.arn
    },
    {
      name      = "AUTHORIZE_PORT"
      valueFrom = data.aws_ssm_parameter.authorize_port.arn
    },
    {
      name      = "TOKEN_HOST"
      valueFrom = data.aws_ssm_parameter.token_host.arn
    },
    {
      name      = "TOKEN_PORT"
      valueFrom = data.aws_ssm_parameter.token_port.arn
    },
   {
      name      = "WITH_TRACER"
      valueFrom = module.with_tracer_parameter.parameter_store.arn
    },
    {
      name      = "TRACER_HOST"
      valueFrom = data.aws_ssm_parameter.tracer_host.arn
    },
    {
      name      = "TRACER_PORT"
      valueFrom = data.aws_ssm_parameter.tracer_port.arn
    },
    {
      name      = "TRACER_TOKEN"
      valueFrom = data.aws_secretsmanager_secret.tracer_token.arn
    },
    {
      name      = "FLASK_SUPPORT"
      valueFrom = module.flask_support_parameter.parameter_store.arn
    },
    {
      name      = "TOKEN"
      valueFrom = module.token_secret.secret.arn
    },
    {
      name      = "SERVICE_NAME"
      valueFrom = module.service_name_parameter.parameter_store.arn
    },
    {
      name      = "REALM"
      valueFrom = module.realm_parameter.parameter_store.arn
    },
    {
      name      = "SECRET"
      valueFrom = module.secret_secret.secret.arn
    },
    {
      name      = "EXP_AUTHORIZATION_CODE"
      valueFrom = module.exp_authorization_code_parameter.parameter_store.arn
    },
    {
      name      = "EXP_REFRESH_TOKEN"
      valueFrom = module.exp_refresh_token_parameter.parameter_store.arn
    },
  ]

  enable_lb_integration = true

  lb_integration = {
    target_group_name    = "auth-code-exchange"
    listener_arn         = data.aws_lb_listener.public_https.arn
    priority             = 20
    deregistration_delay = 15

    health_check = {
      path                = "/authorization_code_exchange_api/metrics"
      interval            = 10
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }

    conditions = [{
      field  = "path-pattern"
      values = ["/token*"]
    }]
  }

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
