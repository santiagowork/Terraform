resource "aws_ssm_document" "this" {
  name            = var.name
  document_format = "YAML"
  document_type   = "Automation"

  content = yamlencode({
    schemaVersion = lookup(var.document, "schema_version", "0.3")
    description   = var.document.description
    parameters    = lookup(var.document, "parameters", null)
    assumeRole    = module.iam.iam_role.arn
    mainSteps     = var.document.steps
    outputs       = lookup(var.document, "outputs", null)
  })

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}
