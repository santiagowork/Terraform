resource "aws_codecommit_repository" "this" {
  lifecycle {
    prevent_destroy = true
  }

  repository_name = "eai_${var.application}_${var.name}"
  description     = var.git.description
  default_branch  = lookup(var.git, "default_branch", "master")

  tags = merge(
    { Name = "${var.application}_${var.name}" },
    var.common_tags
  )
}

resource "aws_ecr_repository" "this" {
  lifecycle {
    prevent_destroy = true
  }

  name                 = "eai_${var.application}_${var.name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    { Name = "${var.application}_${var.name}" },
    var.common_tags
  )
}
