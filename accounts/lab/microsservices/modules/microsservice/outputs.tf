output "security_group" {
  value = module.service.security_group
}

output "iam_role_task_execution" {
  value = module.task_definition.iam_role_task_execution
}
