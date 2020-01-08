module "password" {
  source = "../secret"

  name                 = "password-redis-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags
  aws                  = var.aws
  kms_key              = var.secret_kms_key

  kms_alias = {
    prefix = var.secret_kms_alias_prefix
  }

  secret = merge(
    { description = "Password token for Redis ${var.name}" },
    var.password_secret
  )
}

resource "random_id" "first_password" {
  byte_length = 14
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = module.password.secret.id
  secret_string = random_id.first_password.hex
}
