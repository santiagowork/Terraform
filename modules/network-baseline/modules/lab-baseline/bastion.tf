data "aws_ami" "bastion" {
  most_recent = true
  owners      = [var.bastion.ami.owner]

  filter {
    name   = "name"
    values = [var.bastion.ami.name]
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

module "bastion" {
  source = "../../../autoscaling-group/"

  name        = "bastion-${var.project}-${var.environment}"
  common_tags = local.common_tags
  aws         = var.aws

  vpc = {
    id                       = module.baseline.vpc.id
    extra_security_group_ids = [module.baseline.endpoint_access_security_group.id]
  }

  iam_role = merge(
    { description = "AWS permissions for bastion host on ${var.project}-${var.environment}" },
    lookup(var.bastion, "iam_role", {})
  )

  security_group = merge(
    { description = "Firewall for bastion host on ${var.project}-${var.environment}" },
    lookup(var.bastion, "security_group", {})
  )

  security_group_ingress_rules = local.bastion_security_group.extra_ingress_rules
  security_group_egress_rules = merge(
    {
      dns = {
        description = "DNS"
        protocol    = "udp"
        from_port   = 53
        to_port     = 53
        cidr_blocks = ["0.0.0.0/0"]
      }

      https = {
        description = "HTTPS"
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_blocks = ["0.0.0.0/0"]
      }

      http = {
        description = "HTTP"
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
      }

      imcp = {
        description = "ICMP"
        protocol    = "icmp"
        from_port   = -1
        to_port     = -1
        cidr_blocks = ["0.0.0.0/0"]
      }
    },
    local.bastion_security_group.extra_egress_rules
  )

  log_group = {
    kms_key_arn = var.baseline.log_kms_key_arn
  }

  launch_template = merge(
    { description = "Bastion host baseline for ${var.project}-${var.environment}" },
    var.bastion.launch_template,
    { image_id = data.aws_ami.bastion.image_id }
  )

  autoscaling_group = merge(
    lookup(var.bastion, "autoscaling_group", {}),
    {
      vpc_zone_identifier = values(module.system_networks.subnets).*.id
      max_size            = lookup(var.bastion, "active", false) ? 1 : 0
      min_size            = lookup(var.bastion, "active", false) ? 1 : 0
    }
  )
}
