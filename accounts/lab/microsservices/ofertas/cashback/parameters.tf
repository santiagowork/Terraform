module "with_tracer_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/with-tracer"
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

  name        = "/${local.environment}/microsservices/cashback/flask-support"
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

  name        = "/${local.environment}/microsservices/cashback/realm"
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

  name        = "/${local.environment}/microsservices/cashback/service-name"
  common_tags = local.common_tags

  parameter = {
    description = "Service name for Token microsservice"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "version_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/version-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "Version Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "router_list_offers_parameter"{
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/router-list-offers-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "Router List Offers Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "host_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/host-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "Host Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "port_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/port-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "Port Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "db_host_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/db-host-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "DB Host Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "db_port_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/db-port-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "DB Port Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "db_database_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/db-database-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "DB Database Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "db_username_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/db-username-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "DB Username Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}

module "db_password_parameter" {
  source = "../../../../../modules/parameter-store"

  providers = {
    aws = aws.lab
  }

  name        = "/${local.environment}/microsservices/cashback/db-password-parameter"
  common_tags = local.common_tags

  parameter = {
    description = "DB Password Parameter"
    kms_key_id  = data.aws_kms_key.parameters.arn
  }
}
