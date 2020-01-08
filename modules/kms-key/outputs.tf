output "kms_key" {
  value = aws_kms_key.this[0]
}

output "kms_alias" {
  value = aws_kms_alias.this[0]
}
