resource "random_id" "instance_profile" {
  count = var.random_suffix_length > 0 ? 1 : 0

  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name = var.name
    path = module.iam.iam_role.path
  }
}

resource "aws_iam_instance_profile" "this" {
  lifecycle {
    create_before_destroy = true
  }

  name = var.random_suffix_length > 0 ? random_id.instance_profile.0.hex : var.name
  role = module.iam.iam_role.name
  path = module.iam.iam_role.path
}
