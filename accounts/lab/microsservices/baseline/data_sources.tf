data "aws_region" "this" {
  provider = aws.lab
}

data "aws_caller_identity" "this" {
  provider = aws.lab
}

data "aws_vpc" "rdeai_lab" {
  provider = aws.lab

  tags = {
    Name = "${local.business_unit}-${local.environment}"
  }
}

data "aws_subnet_ids" "publics" {
  provider = aws.lab
  vpc_id   = data.aws_vpc.rdeai_lab.id

  tags = {
    Public = true
  }
}

data "aws_ami" "bastion" {
  provider    = aws.lab
  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-1903-English-Core-Base-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_route53_zone" "public_domain" {
  provider     = aws.lab
  name         = "rdeai-lab.net."
  private_zone = false
}
