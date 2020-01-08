locals {
  business_unit = "rdeai"
  environment   = "lab"
  name          = "${local.business_unit}"

  aws = {
    region     = data.aws_region.this.name
    account_id = data.aws_caller_identity.this.account_id
  }

  vpc = {
    id = data.aws_vpc.rdeai_lab.id
  }

  common_tags = {
    Layer       = "microsservice"
    BU          = local.business_unit
    Environment = "lab"
  }

  port = 8001
}
