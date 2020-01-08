data "aws_iam_policy_document" "config_access" {
  statement {
    sid       = "AWSConfigBucketPermissionsCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::config-rdeailab"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSConfigBucketExistenceCheck"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::config-rdeailab"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    sid       = "AWSConfigBucketDelivery"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::config-rdeailab/AWSLogs/${data.aws_caller_identity.this.account_id}/Config/*"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

module "bucket" {
  source = "../../../modules/s3-bucket"

  name                 = "config-rdeailab"
  random_suffix_length = 0
  common_tags          = local.common_tags

  aws = {
    region     = data.aws_region.this.name
    account_id = data.aws_caller_identity.this.account_id
  }

  bucket = {
    sse_algorithm = "AES256"
    custom_policy = data.aws_iam_policy_document.config_access.json

    lifecycle_rules = [
      {
        id = "cleanup-config-snapshots"

        transitions = [
          {
            storage_class = "STANDARD_IA"
            days          = 30
          },
          {
            storage_class = "GLACIER"
            days          = 90
          },
        ]

        noncurrent_version_transitions = [
          {
            storage_class = "STANDARD_IA"
            days          = 30
          },
          {
            storage_class = "GLACIER"
            days          = 90
          },
        ]

        expiration = {
          days = 365
        }

        noncurrent_version_expiration = {
          days = 365
        }
      }
    ]
  }
}
