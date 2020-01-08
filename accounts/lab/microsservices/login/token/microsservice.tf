module "microsservice" {
  source = "../../modules/microsservice"

  application = "login"
  name        = "token"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  git = {
    description = "Servico de token para o Login"
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
    {
      name      = "AUTHORIZATION_CODE_PATH"
      valueFrom = module.authorization_code_path_parameter.parameter_store.arn
    },
    {
      name      = "REFRESH_TOKEN_PATH"
      valueFrom = module.refresh_token_path_parameter.parameter_store.arn
    },
    {
      name      = "GRANT_TYPE_PATH"
      valueFrom = module.grant_type_path_parameter.parameter_store.arn
    },
    {
      name      = "MONGO_ENVIRONMENT"
      valueFrom = module.mongodb_secret.secret.arn
    },
  ]

  enable_lb_integration = false

  security_group_ingress_rules = {
    lb_http = {
      protocol                 = "tcp"
      from_port                = local.port
      to_port                  = local.port
      source_security_group_id = data.aws_security_group.public_lb.id
    }

    autorization_code_exchange = {
      protocol                 = "tcp"
      from_port                = local.port
      to_port                  = local.port
      source_security_group_id = data.aws_security_group.autorization_code_exchange.id
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
