# module "login_test_pipeline" {
#   source = "../container-pipeline"
#
#   name        = "eai_login_test"
#   common_tags = local.common_tags
#   aws         = local.aws
#   vpc         = local.vpc
#
#   build_project = {
#     artifact_bucket_arn  = module.artifact_bucket.bucket.arn
#     artifact_kms_key_arn = module.artifact_encryption.kms_key.arn
#
#     environment = {
#       compute_type = "BUILD_GENERAL1_SMALL"
#       image        = "aws/codebuild/standard:1.0"
#     }
#
#     vpc_config = {
#       subnets               = data.aws_subnet_ids.system.ids
#       extra_security_groups = [data.aws_security_group.endpoint_access.id]
#     }
#   }
#
#   pipeline_log_group = {
#     kms_key_arn       = data.aws_kms_key.logging.arn
#     retention_in_days = 7
#   }
# }
