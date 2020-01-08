module "log" {
  source = "../cloudwatch-log-group"

  name        = "/aws/events/${var.name}"
  common_tags = var.common_tags
  log_group   = var.log_group
}
