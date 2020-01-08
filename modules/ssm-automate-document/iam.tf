module "iam" {
  source = "../iam-role"

  name                 = "ssm-aws-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  role = merge(
    { description = "${var.name} SSM automate document" },
    var.iam_role,
    { services = ["ssm"] }
  )
}
