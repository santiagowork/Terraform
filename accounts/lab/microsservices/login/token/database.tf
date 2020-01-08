module "database" {
  source = "../../../../../modules/documentdb"

  providers = {
    aws = aws.lab
  }

  name        = "login-token"
  common_tags = local.common_tags
  aws         = local.aws
  vpc         = local.vpc

  ebs_kms_key = {
    retention_in_days = 7
  }

  ebs_kms_alias_prefix = local.environment

  password_secret = {
    retention_in_days = 7
  }

  secret_kms_key = {
    retention_in_days = 7
  }

  secret_kms_alias_prefix = local.environment

  security_group = {
    description = "Firewall for login test database"
  }

  security_group_ingress_rules = {
    login_app = {
      source_security_group_id = module.microsservice.security_group.id
      protocol                 = "tcp"
      from_port                = 17017
      to_port                  = 17017
    }
  }

  subnets = data.aws_subnet_ids.data.ids

  parameter_group = {
    family = "docdb3.6"
  }

  cluster = {
    master_username         = "administrator"
    backup_retention_period = 7
  }

  # db_instances = {
  #   "us-east-1a" = {
  #     availability_zone = "us-east-1a"
  #     instance_class    = "db.r5.large"
  #   }
  # }
}
