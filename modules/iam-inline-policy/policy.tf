resource "random_id" "this" {
  count = var.enabled ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name = var.name
  }
}

resource "aws_iam_role_policy" "this" {
  count = var.enabled ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  role   = var.policy.role
  name   = random_id.this.0.hex
  policy = data.aws_iam_policy_document.this.0.json
}
