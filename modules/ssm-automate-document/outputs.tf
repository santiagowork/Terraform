output "ssm_document" {
  value = merge(
    aws_ssm_document.this,
    {
      invoke_arn = "${replace(aws_ssm_document.this.arn, "document/", "automation-definition/")}:$DEFAULT"
    }
  )
}

output "iam_role" {
  value = module.iam.iam_role
}
