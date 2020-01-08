output "security_group" {
  value = module.firewall.security_group
}

output "iam_role" {
  value = module.iam.iam_role
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.this
}

output "cloudwatch_log_group" {
  value = module.logs.log_group
}
