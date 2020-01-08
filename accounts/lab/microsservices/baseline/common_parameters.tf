module "tracer_host_parameter" {
  source = "../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/tracer-host"
  common_tags = local.common_tags

  parameter = {
    description = "The Elasticsearch APM tracer host"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "tracer_port_parameter" {
  source = "../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/tracer-port"
  common_tags = local.common_tags

  parameter = {
    description = "The Elasticsearch APM tracer port"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "tracer_token_secret" {
  source = "../../../../modules/secret"

  providers = {
    aws = aws.lab
  }

  name                 = "${local.environment}/microsservices/tracer-token"
  random_suffix_length = 0
  common_tags          = local.common_tags
  aws                  = local.aws

  kms_key = {
    retention_in_days = 7
  }

  kms_alias = {
    prefix = local.environment
  }

  secret = {
    description             = "Secret token for Elastic APM"
    recovery_window_in_days = 7
  }
}

module "front_host_parameter" {
  source = "../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/front-host"
  common_tags = local.common_tags

  parameter = {
    description = "Test frontend host for login"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "front_port_parameter" {
  source = "../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/front-port"
  common_tags = local.common_tags

  parameter = {
    description = "Test frontend port for login"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "mule_host_parameter" {
  source = "../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/mule-host"
  common_tags = local.common_tags

  parameter = {
    description = "Test frontend host for login"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "mule_port_parameter" {
  source = "../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/mule-port"
  common_tags = local.common_tags

  parameter = {
    description = "Test frontend port for login"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}
module "endpoint_authorize_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/endpoint-authorize"
  common_tags = local.common_tags
  parameter = {
    description = "Endpoint Authorize"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}
module "endpoint_authorize_port_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/endpoint-authorize-port"
  common_tags = local.common_tags
  parameter = {
    description = "Endpoint Authorize Port"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "endpoint_login_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/endpoint-login"
  common_tags = local.common_tags
  parameter = {
    description = "Endpoint Login"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "endpoint_login_port_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/endpoint-login-port"
  common_tags = local.common_tags
  parameter = {
    description = "Endpoint Login Port"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "endpoint_token_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/endpoint-token"
 common_tags = local.common_tags
  parameter = {
    description = "Endpoint Token"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "endpoint_token_port_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/endpoint-token-port"
  common_tags = local.common_tags
  parameter = {
    description = "Endpoint Token Port"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}
module "authorize_host_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/authorize-host"
  common_tags = local.common_tags
  parameter = {
    description = "Authorize Host"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "authorize_port_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/authorize-port"
  common_tags = local.common_tags
  parameter = {
    description = "Authorize Port"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "token_host_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/token-host"
  common_tags = local.common_tags
  parameter = {
    description = "Token Host"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}

module "token_port_parameter" {
  source = "../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/token-port"
  common_tags = local.common_tags
  parameter = {
    description = "Token Port"
    kms_key_id  = module.parameter_store_encryption.kms_key.arn
  }
}
