module "log_encryption" {
  source = "../../../../modules/kms-key"

  providers = {
    aws = aws.lab
  }

  name        = "log/${local.business_unit}"
  common_tags = local.common_tags
  aws         = local.aws

  kms_key = {
    description                    = "Encryption key for logs on ${local.business_unit}"
    deletion_window_in_days        = 7
    enable_cloudwatch_logs_support = true
    enable_cloudtrail_support      = false
  }

  kms_alias = {
    prefix = local.environment
  }
}

module "parameter_store_encryption" {
  source = "../../../../modules/kms-key"

  providers = {
    aws = aws.lab
  }

  name        = "parameters/${local.business_unit}"
  common_tags = local.common_tags
  aws         = local.aws

  kms_key = {
    description             = "Encryption key for parameter stores on ${local.business_unit}"
    deletion_window_in_days = 7
  }

  kms_alias = {
    prefix = local.environment
  }
}
