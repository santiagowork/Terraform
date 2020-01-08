module "microsservice" { 
  source = "../../modules/microsservice" 
 
  application = "login" 
  name        = "api-gateway" 
  common_tags = local.common_tags 
  aws         = local.aws 
  vpc         = local.vpc 
 
  git = { 
    description = "Api gateway para o fluxo de login" 
  } 
 
  log_group = { 
    kms_key_arn       = data.aws_kms_key.logging.arn 
    retention_in_days = 7 
  } 
 
  volumes = [{ 
    name        = "tmp" 
    mount_point = "/tmp" 
  }] 
 
  image_version = "0.3.0" 
 
  port = local.port
 
  secrets = [
    { 
      name = "ENDPOINT_AUTHORIZE" 
      valueFrom = data.aws_ssm_parameter.endpoint_authorize.arn 
    }, 
    { 
      name = "ENDPOINT_AUTHORIZE_PORT" 
      valueFrom = data.aws_ssm_parameter.endpoint_authorize_port.arn
    }, 
    { 
      name  = "ENDPOINT_LOGIN" 
      valueFrom = data.aws_ssm_parameter.endpoint_login.arn 
    }, 
    { 
      name  = "ENDPOINT_LOGIN_PORT" 
      valueFrom = data.aws_ssm_parameter.endpoint_login_port.arn
    }, 
    { 
      name  = "ENDPOINT_TOKEN" 
      valueFrom = data.aws_ssm_parameter.endpoint_token.arn
    }, 
    { 
      name  = "ENDPOINT_TOKEN_PORT" 
      valueFrom = data.aws_ssm_parameter.endpoint_token_port.arn
    }, 
  ] 
 
  enable_lb_integration = true 
 
  lb_integration = { 
    listener_arn         = data.aws_lb_listener.public_https.arn 
    priority             = 5 
    deregistration_delay = 15 
    slow_start           = 300 
 
    health_check = { 
      path                = "/console" 
      interval            = 30 
      healthy_threshold   = 2 
      unhealthy_threshold = 10 
      matcher             = "200-499" 
    } 
 
    conditions = [{ 
      field  = "host-header" 
      values = ["api.rdeai-lab.net"] 
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
 
  task_definition = { 
    memory = 2048 
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
