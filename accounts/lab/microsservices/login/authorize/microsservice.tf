module "microsservice" {
  source = "../../modules/microsservice"

  application = "login"
  name        = "authorize"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  git = {
    description = "Authorization server do login"
  }

  log_group = {
    kms_key_arn       = data.aws_kms_key.logging.arn
    retention_in_days = 7
  }

  volumes = [{
    name        = "tmp"
    mount_point = "/tmp"
  }]

  image_version = "0.4.0"

  port = local.port

  environment = [
    {
      name  = "SERVICE_NAME",
      value = "authorize"
    },
    {
      name  = "CACHE_HOST"
      value = module.cache.elasticache_replication_group.primary_endpoint_address
    },
    {
      name  = "TRACER_PORT",
      value = "443"
    },
    {
      name  = "DB_HOSTS",
      value = "postgresql://${module.database.db_instance.username}:712ad377cdae8349892ab4a3809c@${module.database.db_instance.endpoint}/${module.database.db_instance.name}"
    },
    {
      name  = "FRONT_HOST",
      value = "http://login.rdeai-lab.net"
    },
    {
      name  = "MULE_HOST",
      value = "http://54.197.34.118"
    },
    {
      name  = "REALM",
      value = "template_api"
    },
    {
      name  = "TRACER_TOKEN",
      value = "Zhyr5bHCsU6ctG7pv1"
    },
    {
      name  = "FRONT_PORT",
      value = "80"
    },
    {
      name  = "TRACER_HOST",
      value = "https://e3d2d6717a0a4a56906da164159349da.apm.us-east-1.aws.cloud.es.io"
    },
    {
      name  = "MULE_PORT",
      value = "8081"
    },
    {
      name  = "FLASK_SUPPORT",
      value = "false"
    },
    {
      name  = "CACHE_PORT",
      value = tostring(module.cache.elasticache_replication_group.port)
    },
    {
      name  = "WITH_TRACER",
      value = "true"
    },
    {
      name  = "TOKEN",
      value = "123"
    },
  ]

  secrets = [
    {
      name      = "CACHE_PASSWORD"
      valueFrom = module.cache.secret.arn
    }
  ]

  enable_lb_integration = true

  lb_integration = {
    listener_arn         = data.aws_lb_listener.public_https.arn
    priority             = 30
    deregistration_delay = 15

    health_check = {
      path                = "/authorize/metrics"
      interval            = 10
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }

    conditions = [
      {
        field  = "path-pattern"
        values = ["/authorize*"]
      }
    ]
  }

  security_group_ingress_rules = {
    lb_http = {
      protocol                 = "tcp"
      from_port                = local.port
      to_port                  = local.port
      source_security_group_id = data.aws_security_group.public_lb.id
    }

    login_orchestrator = {
      protocol                 = "tcp"
      from_port                = local.port
      to_port                  = local.port
      source_security_group_id = data.aws_security_group.login_orchestrator.id
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
