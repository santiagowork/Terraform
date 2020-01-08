output "security_group" {
  value = module.ec2_base.security_group
}

output "iam_role" {
  value = module.ec2_base.iam_role
}

output "iam_instance_profile" {
  value = module.ec2_base.iam_instance_profile
}

output "cloudwatch_log_group" {
  value = module.ec2_base.cloudwatch_log_group
}

output "launch_template" {
  value = aws_launch_template.this
}

# output "event_rule_launch_success" {
#   value = aws_cloudwatch_event_rule.launch_success
# }
