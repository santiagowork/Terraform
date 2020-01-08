resource "aws_db_subnet_group" "this" {
  name        = var.name
  description = "Database networks for ${var.name}"
  subnet_ids  = var.subnets

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )
}
