output "security_group" {
  value = module.firewall.security_group
}

output "elasticache_replication_group" {
  value = merge(
    aws_elasticache_replication_group.this,
    { port = lookup(var.elasticache, "port", 6379) }
  )
}

output "secret" {
  value = module.password.secret
}
