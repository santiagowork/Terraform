locals {
  business_unit = "rdeai"
  environment   = "lab"
  name          = "${local.business_unit}-${local.environment}"

  dns = {
    mode   = "cloud_map"
    domain = "${local.name}.cloud"
  }

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  aws = {
    region     = data.aws_region.this.name
    account_id = data.aws_caller_identity.this.account_id
  }

  vpc = {
    cidr_block = "172.29.0.0/22"
  }

  public_networks = {
    addresses_number        = 256
    map_public_ip_on_launch = true

    network_acl_ingress_rules = {
      allow_all = {
        rule_number = 100
        rule_action = "allow"
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    }

    network_acl_egress_rules = {
      allow_all = {
        rule_number = 100
        rule_action = "allow"
        protocol    = -1
        cidr_block  = "0.0.0.0/0"
      }
    }
  }

  common_tags = {
    Layer = "networking"
  }
}
