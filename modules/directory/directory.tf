resource "aws_directory_service_directory" "this" {
  name        = var.directory.domain
  short_name  = var.directory.short_name
  type        = lookup(var.directory, "type", null)
  edition     = lookup(var.directory, "edition", null)
  description = var.directory.description
  size        = lookup(var.directory, "size", null)
  password    = aws_secretsmanager_secret_version.password.secret_string
  alias       = lookup(var.directory, "alias", null)
  enable_sso  = lookup(var.directory, "enable_sso", false)

  vpc_settings {
    vpc_id     = var.vpc.id
    subnet_ids = var.vpc.subnets
  }

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
