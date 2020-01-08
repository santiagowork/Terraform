# data "aws_iam_policy_document" "config_access" {
#   statement {
#     sid       = "AWSConfigBucketPermissionsCheck"
#     effect    = "Allow"
#     actions   = ["s3:GetBucketAcl"]
#     resources = ["arn:aws:s3:::config-rdeailab"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["config.amazonaws.com"]
#     }
#   }
#
#   statement {
#     sid       = "AWSConfigBucketExistenceCheck"
#     effect    = "Allow"
#     actions   = ["s3:ListBucket"]
#     resources = ["arn:aws:s3:::config-rdeailab"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["config.amazonaws.com"]
#     }
#   }
#
#   statement {
#     sid       = "AWSConfigBucketDelivery"
#     effect    = "Allow"
#     actions   = ["s3:PutObject"]
#     resources = ["arn:aws:s3:::config-rdeailab/AWSLogs/${data.aws_caller_identity.this.account_id}/Config/*"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["config.amazonaws.com"]
#     }
#   }
# }

module "bucket" {
  source = "../../../modules/s3-bucket"

  name                 = local.domain
  random_suffix_length = 0
  common_tags          = local.common_tags
  aws                  = local.aws

  bucket = {
    kms_key_arn = module.bucket_encryption.kms_key.arn
    # custom_policy = data.aws_iam_policy_document.config_access.json
  }
}
