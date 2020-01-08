output "nat_instance_security_group" {
  value = module.autoscaling.security_group
}

output "internet_access_security_group" {
  value = module.internet_access.security_group
}

output "iam_role" {
  value = module.autoscaling.iam_role
}

output "iam_instance_profile" {
  value = module.autoscaling.iam_instance_profile
}

output "cloudwatch_log_group" {
  value = module.autoscaling.cloudwatch_log_group
}

output "logs_kms_key" {
  value = module.autoscaling.logs_kms_key
}

output "logs_kms_alias" {
  value = module.autoscaling.logs_kms_alias
}

output "launch_template" {
  value = module.autoscaling.launch_template
}

output "eip" {
  value = aws_eip.this
}
