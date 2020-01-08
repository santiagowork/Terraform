data "aws_region" "this" {
  provider = aws.lab
}

data "aws_caller_identity" "this" {
  provider = aws.lab
}
