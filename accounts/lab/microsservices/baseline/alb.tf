module "public_alb" {
  source = "../../../../modules/alb"

  providers = {
    aws = aws.lab
  }

  name        = "rdeai-apps-${local.environment}"
  common_tags = local.common_tags
  vpc         = local.vpc

  security_group_ingress_rules = {
    api_gateway = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  security_group_egress_rules = {
    all_traffic = {
      protocol    = "all"
      from_port   = -1
      to_port     = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dns = {
    enabled            = true
    zone_id            = data.aws_route53_zone.public_domain.id
    domain_name        = "api.${local.public_domain_name}"
    extra_domain_names = ["backend.${local.public_domain_name}"]
  }

  lb = {
    internal = false
    subnets  = data.aws_subnet_ids.publics.ids
  }
}
