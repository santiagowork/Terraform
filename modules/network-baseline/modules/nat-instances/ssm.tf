resource "aws_ssm_document" "debian_strech_update" {
  name            = "debian-stretch-update"
  document_type   = "Command"
  document_format = "YAML"
  content         = file("${path.module}/ssm/documents/debian/stretch/update.yml")

  tags = merge(
    map("Name", "debian-stretch-update"),
    local.common_tags
  )
}

resource "aws_ssm_document" "debian_strech_enable_nat" {
  name            = "debian-stretch-enable-nat"
  document_type   = "Command"
  document_format = "YAML"
  content         = file("${path.module}/ssm/documents/debian/stretch/enable-nat.yml")

  tags = merge(
    map("Name", "debian-stretch-enable-nat"),
    local.common_tags
  )
}

data "aws_iam_policy_document" "aws_config_nat" {
  statement {
    sid       = "ConfigureNAT"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AssociateAddress",
      "ec2:ModifyInstanceAttribute",
      "ec2:DeleteRoute",
      "ec2:CreateRoute",
      "ssm:SendCommand",
      "ssm:DescribeInstanceInformation",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations"
    ]

    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:ResourceTag/NatInstanceInfrastructure"
    #   values   = ["true"]
    # }
  }
}

module "ssm_config_nat" {
  source = "../ssm-automate-document"

  name                 = "config-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = local.common_tags

  document = {
    description = "Configures AWS networking and instance for NAT"

    parameters = {
      InstanceId = {
        type        = "String"
        description = "(Required) The EC2 instance id"
      }

      PublicIp = {
        type        = "String"
        description = "(Required) The EIP public address"
      }
    }

    steps = concat([
      {
        name   = "AssociatePublicAddress"
        action = "aws:executeAwsApi"
        inputs = {
          Service    = "ec2"
          Api        = "AssociateAddress"
          InstanceId = "{{ InstanceId }}"
          PublicIp   = "{{ PublicIp }}"
        }
      },
      {
        name   = "DisableSrcDstCheck"
        action = "aws:executeAwsApi"
        inputs = {
          Service    = "ec2"
          Api        = "ModifyInstanceAttribute"
          InstanceId = "{{ InstanceId }}"
          SourceDestCheck = {
            Value = false
          }
        }
      }
      ],
      flatten([for rt in local.vpc.private_route_tables : [
        {
          name      = "DeleteRoute${index(local.vpc.private_route_tables, rt)}"
          action    = "aws:executeAwsApi"
          nextStep  = "AddRoute${index(local.vpc.private_route_tables, rt)}"
          onFailure = "Continue"
          inputs = {
            Service              = "ec2"
            Api                  = "DeleteRoute"
            RouteTableId         = rt
            DestinationCidrBlock = "0.0.0.0/0"
          }
        },
        {
          name   = "AddRoute${index(local.vpc.private_route_tables, rt)}"
          action = "aws:executeAwsApi"
          inputs = {
            Service              = "ec2"
            Api                  = "CreateRoute"
            RouteTableId         = rt
            InstanceId           = "{{ InstanceId }}"
            DestinationCidrBlock = "0.0.0.0/0"
          }
        }
      ]]),
      [
        {
          name     = "CheckInstance"
          action   = "aws:waitForAwsResourceProperty"
          nextStep = "ConfigureLinux"
          inputs = {
            Service = "ssm"
            Api     = "DescribeInstanceInformation"
            InstanceInformationFilterList = [{
              key      = "InstanceIds"
              valueSet = ["{{ InstanceId }}"]
            }]
            PropertySelector = "InstanceInformationList[0].InstanceId"
            DesiredValues    = ["{{ InstanceId }}"]
          }
        },
        {
          name   = "ConfigureLinux"
          action = "aws:runCommand"
          isEnd  = true
          inputs = {
            DocumentName = aws_ssm_document.debian_strech_enable_nat.name
            InstanceIds  = ["{{ InstanceId }}"]
          }
        }
      ]
    )
  }

  role = {
    inline_policies = {
      configure-nat = data.aws_iam_policy_document.aws_config_nat.json
    }
  }
}
