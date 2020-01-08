output "secret" {
  value = aws_secretsmanager_secret.this
}

output "kms_key" {
  value = module.encryption.kms_key
}

output "kms_alias" {
  value = module.encryption.kms_alias
}
