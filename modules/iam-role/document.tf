locals {
  role_type = lookup(var.role, "type", "service")
}

data "aws_iam_policy_document" "service" {
  count = local.role_type == "service" ? 1 : 0

  statement {
    sid     = replace(title(var.name), "/[_-]/", "")
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = formatlist("%s.amazonaws.com", var.role.services)
    }
  }
}

data "aws_iam_policy_document" "assumable" {
  count = local.role_type == "assumable" ? 1 : 0

  statement {
    sid     = replace(title(var.name), "-", "")
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = concat(
        formatlist("arn:aws:iam::%s:root", lookup(var.role, "source_account_ids", [])),
        lookup(var.role, "source_role_arns", [])
      )
    }
  }
}
