module "bucket_encryption" {
  source = "../../../modules/kms-key"

  providers = {
    aws = aws.lab
  }

  name        = "s3/${replace(local.domain, ".", "-")}"
  common_tags = local.common_tags
  aws         = local.aws

  kms_key = {
    description             = "Encryption key for login frontend on ${local.business_unit}"
    deletion_window_in_days = 7
  }

  kms_alias = {
    prefix = local.environment
  }
}
