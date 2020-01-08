module "endpoint_authorize_parameter" {
  source = "../../../../../modules/parameter-store"
 
  providers = {
    aws = aws.lab
  }
  
  name        = "/${local.environment}/microsservices/api-gateway/endpoint-authorize"
  common_tags = local.common_tags
 
  parameter = {
   description = "endpoint-authorize_parameter"
   kms_key_id  = data.aws_kms_key.parameters.arn
  }
 }

module "endpoint_authorize_port_parameter" {
  source = "../../../../../modules/parameter-store"
 
  providers = {
    aws = aws.lab
  }
 
  name        = "/${local.environment}/microsservices/api-gateway/endpoint-authorize-port"
  common_tags = local.common_tags
 
  parameter = {
    description = "endpoint_authorize-port-parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
   }
 }

module "endpoint_login" {
  source = "../../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/api-gateway/endpoint-login"
  common_tags = local.common_tags
  parameter = {
    description = "endpoint_login-parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "endpoint_login_port" {
  source = "../../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/api-gateway/endpoint-login-port"
  common_tags = local.common_tags
  parameter = {
    description = "endpoint-login-port-parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "endpoint_token" {
  source = "../../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/api-gateway/endpoint-token"
  common_tags = local.common_tags
  parameter = {
    description = "endpoint-token-parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "endpoint_token_port" {
  source = "../../../../../modules/parameter-store"
  providers = {
    aws = aws.lab
  }
  name        = "/${local.environment}/microsservices/api-gateway/endpoint-token-port"
  common_tags = local.common_tags
  parameter = {
    description = "endpoint-token-port-parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}
