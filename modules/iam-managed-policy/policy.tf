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

resource "aws_iam_policy" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name        = var.random_suffix_length > 0 ? random_id.this.0.hex : var.name
  policy      = data.aws_iam_policy_document.this.json
  description = var.policy.description
  path        = lookup(var.policy, "path", "/")
}
