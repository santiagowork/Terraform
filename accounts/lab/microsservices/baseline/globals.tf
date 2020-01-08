locals {
  business_unit      = "rdeai"
  environment        = "lab"
  name               = "${local.business_unit}"
  public_domain_name = "rdeai-lab.net"

  aws = {
    region     = data.aws_region.this.name
    account_id = data.aws_caller_identity.this.account_id
  }

  vpc = {
    id = data.aws_vpc.rdeai_lab.id
  }

  common_tags = {
    Layer       = "applications"
    BU          = local.business_unit
    Environment = "lab"
  }
}
