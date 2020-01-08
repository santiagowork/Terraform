module "disk_encryption" {
  source = "../kms-key"

  name        = "documentdb/ebs/${var.name}"
  common_tags = var.common_tags
  aws         = var.aws

  kms_key = merge(
    { description = "Encryption key for disk blocks on ${var.name} DocumentDB" },
    var.ebs_kms_key
  )

  kms_alias = {
    prefix = var.ebs_kms_alias_prefix
  }
}
