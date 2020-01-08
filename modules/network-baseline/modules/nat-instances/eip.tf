resource "aws_eip" "this" {
  vpc = true

  tags = merge(
    { Name = var.name },
    local.common_tags
  )
}
