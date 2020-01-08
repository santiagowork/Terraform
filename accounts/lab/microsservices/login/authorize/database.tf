module "database" {
  source = "../../../../../modules/rds/modules/postgresql"

  providers = {
    aws = aws.lab
  }

  name        = "login-authorize"
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
    description = "Firewall for login authorize database"
  }

  security_group_ingress_rules = {
    login_app = {
      source_security_group_id = module.microsservice.security_group.id
      protocol                 = "tcp"
      from_port                = 5432
      to_port                  = 5432
    }
  }

  subnets = data.aws_subnet_ids.data.ids

  rds = {
    engine_version      = "11"
    instance_class      = "db.t3.micro"
    username            = "administrator"
    database_name       = "authorize"
    allocated_storage   = 20
    deletion_protection = false
    multi_az            = true
    skip_final_snapshot = true
  }
}
