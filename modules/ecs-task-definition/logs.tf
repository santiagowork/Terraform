module "logs" {
  source = "../cloudwatch-log-group"

  name        = "/ecs/${var.name}"
  common_tags = var.common_tags

  log_group = merge(
    var.log_group
  )
}
