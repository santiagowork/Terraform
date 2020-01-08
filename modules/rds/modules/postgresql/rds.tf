module "rds" {
  source = "../../"

  name                         = var.name
  random_suffix_length         = var.random_suffix_length
  common_tags                  = var.common_tags
  aws                          = var.aws
  vpc                          = var.vpc
  ebs_kms_key                  = var.ebs_kms_key
  ebs_kms_alias_prefix         = var.ebs_kms_alias_prefix
  secret_kms_key               = var.secret_kms_key
  secret_kms_alias_prefix      = var.secret_kms_alias_prefix
  security_group               = var.security_group
  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules  = var.security_group_egress_rules
  subnets                      = var.subnets
  password_secret              = var.password_secret

  parameter_group = {
    family = "postgres11"

    parameters = concat(
      local.default_pgsql_parameters,
      var.parameters
    )
  }

  rds = merge(
    { port = 5432 },
    var.rds,
    { engine = "postgres" }
  )
}
