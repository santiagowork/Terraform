module "encryption" {
  source = "../kms-key"

  name        = "secretmanager/${var.name}"
  common_tags = var.common_tags
  aws         = var.aws

  kms_key = merge(
    { description = "Encryption key for secret manager ${var.name}" },
    var.kms_key
  )

  kms_alias = var.kms_alias
}
