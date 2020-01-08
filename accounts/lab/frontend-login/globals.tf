locals {
  business_unit = "rdeai"
  environment   = "lab"

  domain = "login.rdeai-lab.net"

  aws = {
    region     = data.aws_region.this.name
    account_id = data.aws_caller_identity.this.account_id
  }

  common_tags = {
    Layer       = "frontend"
    BU          = local.business_unit
    Environment = "lab"
  }
}
