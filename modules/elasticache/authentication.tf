# resource "random_id" "auth" {
#   keepers = {
#     name           = "${var.name}"
#     subnet_ids     = "${join(",", var.subnet_ids)}"
#     engine_version = "${var.engine_version}"
#   }
#
#   byte_length = "14"
# }
#
# resource "aws_ssm_parameter" "redis_auth" {
#   name      = "redis-auth"
#   type      = "SecureString"
#   value     = "${random_id.auth.b64}"
#   key_id    = "${var.parameter_key_kms_arn}"
#   overwrite = true
#
#   tags = "${merge(
#     map("Name", "redis-auth"),
#     var.common_tags
#   )}"
# }
