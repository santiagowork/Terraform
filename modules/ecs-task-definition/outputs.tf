output "iam_role_task_execution" {
  value = module.iam_task_execution.iam_role
}

output "iam_role_task" {
  value = module.iam_task.iam_role
}

output "task_definition" {
  value = aws_ecs_task_definition.this
}

output "log_group" {
  value = module.logs.log_group
}
