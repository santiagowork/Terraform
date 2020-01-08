module "autoscaling" {
  source = "../autoscaling-group"

  name                 = var.name
  random_suffix_length = var.random_suffix_length
  common_tags          = local.common_tags
  vpc                  = local.vpc
  role                 = local.role
  logs_kms_key         = local.logs_kms_key
  logs_kms_alias       = local.logs_kms_alias

  security_group = {
    ingress_rules = local.nat_ingress_rules
    egress_rules  = local.internet_access_egress
  }

  launch_template = local.launch_template

  autoscaling_group = merge(
    local.autoscaling_group,
    {
      enabled_events = {
        launch_instance_success = true
      }
    }
  )
}

data "aws_iam_policy_document" "event_config_nat_activate_automation" {
  statement {
    sid       = "ActivateAutomation"
    effect    = "Allow"
    actions   = ["ssm:StartAutomationExecution"]
    resources = [module.ssm_config_nat.ssm_document.invoke_arn]
  }
}

module "iam_event_config_nat" {
  source = "../iam-role/modules/service-role"

  name                 = "event-config-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags
  services             = ["events"]

  role = {
    description = "Allow event run NAT automation"
    inline_policies = {
      start-automation = data.aws_iam_policy_document.event_config_nat_activate_automation.json
    }
  }
}

resource "aws_cloudwatch_event_target" "ssm_automate_config_nat" {
  target_id = "ConfigNat"
  arn       = module.ssm_config_nat.ssm_document.invoke_arn
  rule      = module.autoscaling.event_rule_launch_success.name
  role_arn  = module.iam_event_config_nat.iam_role.arn

  input_transformer {
    input_paths = {
      instanceID = "$.detail.EC2InstanceId"
    }

    input_template = templatefile("${path.module}/data/template-input-transformer-launch-success.json", {
      public_ip = aws_eip.this.public_ip
    })
  }
}
