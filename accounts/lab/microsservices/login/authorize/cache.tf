module "cache" {
  source = "../../../../../modules/elasticache"

  providers = {
    aws = aws.lab
  }

  name        = "login-authorize"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  security_group = {
    description = "Firewall for login authorize cache"
  }

  security_group_ingress_rules = {
    authorize_app = {
      source_security_group_id = module.microsservice.security_group.id
      protocol                 = "tcp"
      from_port                = 6379
      to_port                  = 6379
    }
  }

  password_secret = {
    retention_in_days = 7
  }

  secret_kms_key = {
    retention_in_days = 7
  }

  elasticache = {
    family                        = "redis5.0"
    engine_version                = "5.0.5"
    node_type                     = "cache.t3.micro"
    replication_group_description = "Authorize cache"
    subnets                       = data.aws_subnet_ids.data.ids
    maintenance_window            = "sun:04:00-sun:06:00"
    snapshot_window               = "06:00-07:00"
    transit_encryption_enabled    = false
  }
}
