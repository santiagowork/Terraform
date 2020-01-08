module "role" {
  source = "../iam-role"

  name                 = "config-${var.name}"
  random_suffix_length = var.random_suffix_length
  common_tags          = var.common_tags

  role = {
    description = "AWS Config role for account"
    role_type   = "service"
    services    = ["config"]
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = module.role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
