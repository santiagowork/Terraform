resource "random_id" "this" {
  count = var.random_suffix_length > 0 ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name = var.name
  }
}

resource "aws_iam_role" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name                  = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name
  assume_role_policy    = local.role_type == "service" ? data.aws_iam_policy_document.service.0.json : data.aws_iam_policy_document.assumable.0.json
  description           = var.role.description
  path                  = lookup(var.role, "path", "/")
  max_session_duration  = lookup(var.role, "max_session_duration", 3600)
  force_detach_policies = lookup(var.role, "force_detach_policies", true)
  permissions_boundary  = lookup(var.role, "permissions_boundary", null)

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
