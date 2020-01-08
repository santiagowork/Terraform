resource "random_id" "this" {
  lifecycle {
    create_before_destroy = true
  }

  prefix      = "${var.name}-"
  byte_length = var.random_suffix_length / 2

  keepers = {
    name           = var.name
    subnet_ids     = join(",", var.elasticache.subnets)
    engine_version = var.elasticache.engine_version
    auth_token     = aws_secretsmanager_secret_version.password.secret_string
  }
}

resource "aws_elasticache_replication_group" "this" {
  lifecycle {
    create_before_destroy = true
  }

  replication_group_id          = random_id.this.hex
  replication_group_description = var.elasticache.replication_group_description
  engine_version                = var.elasticache.engine_version
  node_type                     = var.elasticache.node_type
  number_cache_clusters         = lookup(var.elasticache, "number_cache_clusters", 2)
  automatic_failover_enabled    = lookup(var.elasticache, "automatic_failover_enabled", true)
  parameter_group_name          = aws_elasticache_parameter_group.this.id
  port                          = lookup(var.elasticache, "port", 6379)
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  maintenance_window            = var.elasticache.maintenance_window
  apply_immediately             = lookup(var.elasticache, "apply_immediately", true)
  snapshot_window               = lookup(var.elasticache, "snapshot_window", "06:00-07:00")
  snapshot_retention_limit      = lookup(var.elasticache, "snapshot_retention_limit", 0)
  notification_topic_arn        = lookup(var.elasticache, "notification_topic_arn", null)
  transit_encryption_enabled    = lookup(var.elasticache, "transit_encryption_enabled", true)
  at_rest_encryption_enabled    = true
  # auth_token                    = aws_secretsmanager_secret_version.password.secret_string

  security_group_ids = concat(
    [module.firewall.security_group.id],
    lookup(var.elasticache, "extra_security_group_ids", [])
  )

  tags = merge(
    map("Name", var.name),
    var.common_tags
  )
}
