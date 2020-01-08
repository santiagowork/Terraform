module "microsservice" {
  source = "../../modules/microsservice"

  application = "login"
  name        = "login-orchestrator"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  git = {
    description = "Orquestrador de login"
  }

  log_group = {
    kms_key_arn       = data.aws_kms_key.logging.arn
    retention_in_days = 7
  }

  volumes = [{
    name        = "tmp"
    mount_point = "/tmp"
  }]

  image_version = "2fa"

  port = local.port

  environment = [
    {
      name  = "AUTHORIZE_HOST"
      value = "http://eai_login_authorize"
    },
    {
      name  = "AUTHORIZE_PORT",
      value = "8003"
    },
    {
      name  = "FLASK_SUPPORT",
      value = "false"
    },
    {
      name  = "LOGIN_KMV_HOST",
      value = "http://www.homologacaokmv.com.br"
    },
    {
      name  = "REALM",
      value = "template_api"
    },
    {
      name  = "SERVICE_NAME",
      value = "template_api"
    },
    {
      name  = "TRACER_HOST",
      value = "https://e3d2d6717a0a4a56906da164159349da.apm.us-east-1.aws.cloud.es.io"
    },
    {
      name  = "TRACER_PORT",
      value = "443"
    },
    {
      name  = "TRACER_TOKEN",
      value = "Zhyr5bHCsU6ctG7pv1"
    },
    {
      name  = "WITH_TRACER",
      value = "true"
    },
    {
      name  = "FRONT_HOST",
      value = "http://login.rdeai-lab.net"
    },
    {
      name  = "FRONT_PORT",
      value = "80"
    },
    {
      name  = "DEBUG_MODE",
      value = "True"
    },
  ]

  enable_lb_integration = true

  lb_integration = {
    listener_arn         = data.aws_lb_listener.public_https.arn
    priority             = 10
    deregistration_delay = 15

    health_check = {
      path                = "/login_orchestrator/metrics"
      interval            = 10
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }

    conditions = [{
      field  = "path-pattern"
      values = ["/login*"]
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
