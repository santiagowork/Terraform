resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.role_names

  lifecycle {
    create_before_destroy = true
  }

  role       = each.value
  policy_arn = aws_iam_policy.this.arn
}
