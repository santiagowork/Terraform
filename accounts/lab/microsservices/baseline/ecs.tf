resource "aws_ecs_cluster" "this" {
  provider = aws.lab

  name = local.name

  tags = merge(
    { Name = local.name },
    local.common_tags
  )

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
