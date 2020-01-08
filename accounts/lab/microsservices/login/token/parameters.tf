module "with_tracer_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/with-tracer"
  common_tags = local.common_tags

  parameter = {
    description = "If the tracer must be anabled or not for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "flask_support_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/flask-support"
  common_tags = local.common_tags

  parameter = {
    description = "Flask support for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "realm_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/realm"
  common_tags = local.common_tags

  parameter = {
    description = "Authentication realm for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "service_name_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/service-name"
  common_tags = local.common_tags

  parameter = {
    description = "Service name for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "exp_authorization_code_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/exp-authorization-code"
  common_tags = local.common_tags

  parameter = {
    description = "Authorization code expiration in milisseconds for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "exp_refresh_token_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/exp-refresh-token"
  common_tags = local.common_tags

  parameter = {
    description = "Refresh token expiration in milisseconds for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "authorization_code_path_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/authorization-code-path"
  common_tags = local.common_tags

  parameter = {
    description = "Authorization code json path for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "grant_type_path_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/grant-type-path"
  common_tags = local.common_tags

  parameter = {
    description = "Grant type json path for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "refresh_token_path_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/token/refresh-token-path"
  common_tags = local.common_tags

  parameter = {
    description = "Refresh token json path for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "token_secret" {
  source = "../../../../../modules/secret"

  providers = {
    aws = aws.lab
  }

  name                 = "${local.environment}/microsservices/token/token"
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
    description             = "Access token for Token microsservice"
    recovery_window_in_days = 7
  }
}

module "secret_secret" {
  source = "../../../../../modules/secret"

  providers = {
    aws = aws.lab
  }

  name                 = "${local.environment}/microsservices/token/secret"
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
    description             = "Secret for Token microsservice"
    recovery_window_in_days = 7
  }
}

module "mongodb_secret" {
  source = "../../../../../modules/secret"

  providers = {
    aws = aws.lab
  }

  name                 = "${local.environment}/microsservices/token/mongodb"
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
    description             = "MongoDB url for Token microsservice"
    recovery_window_in_days = 7
  }
}
