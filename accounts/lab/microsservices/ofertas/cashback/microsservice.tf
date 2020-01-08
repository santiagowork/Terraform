module "microsservice" {
  source = "../../modules/microsservice"

  application = "ofertas"

  name        = "cashback"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  git = {
    description = "Repositório para o serviço que irá ofertar e utilizar o cashback mediante dados do participante"
  }

  log_group = {
    kms_key_arn       = data.aws_kms_key.logging.arn
    retention_in_days = 7
  }

  volumes = [{
    name        = "tmp"
    mount_point = "/tmp"
  }]

  image_version = "0.1.0"

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
      name      = "HOST_GATEWAY"
      valueFrom = module.host_gateway_parameter.parameter_store.arn
    },
    {
      name      = "VERSION"
      valueFrom = module.version_parameter.parameter_store.arn
    },
    {
      name      = "ROUTER_LIST_OFFERS"
      valueFrom = module.router_list_offers_parameter.parameter_store.arn
    },
    {
      name      = "HOST"
      valueFrom = module.host_parameter_parameter_store.arn
    },
    {
      name      = "PORT"
      valueFrom = module.port_parameter.parameter_store.arn
    },
    {
      name      = "DB_HOST"
      valueFrom = module.db_host_parameter.parameter_store.arn
    },
    {
      name      = "DB_PORT"
      valueFrom = module.db_port_parameter.parameter_store.arn
    },
    {
      name      = "DB_DATABASE"
      valueFrom = module.db_database_parameter.parameter_store.arn
    },
    {
      name      = "DB_USERNAME"
      valueFrom = module.db_username_parameter.parameter_store.arn
    },
    {
      name      = "DB_PASSWORD"
      valueFrom = module.db_password_parameter.parameter_store.arn
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
