# resource "aws_cloudtrail" "this" {
#   name                          = var.name
#   enable_logging                = true
#   include_global_service_events = true
#   is_multi_region_trail         = true
#   enable_log_file_validation    = true
#   kms_key_id                    = var.trail.kms_key_arn
#   s3_bucket_name                = var.trail.bucket
#   s3_key_prefix                 = lookup(var.trail, "s3_key_prefix", null)
#   cloud_watch_logs_role_arn     = module.iam.iam_role.arn
#   cloud_watch_logs_group_arn    = module.logs.log_group.arn
#
#   # event_selector
#
#   tags = merge(
#     var.common_tags,
#     { Name = var.name }
#   )
# }
