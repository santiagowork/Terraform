resource "aws_docdb_cluster" "this" {
  // baseline
  cluster_identifier = var.name
  engine             = lookup(var.cluster, "engine", "docdb")
  engine_version     = lookup(var.cluster, "engine_version", "3.6.0")

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )

  // configuration
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name
  apply_immediately               = lookup(var.cluster, "apply_immediately", false)
  preferred_maintenance_window    = lookup(var.cluster, "preferred_maintenance_window", "sat:21:00-sun:00:00")

  // authentication
  master_username = var.cluster.master_username
  master_password = aws_secretsmanager_secret_version.password.secret_string

  // backup
  backup_retention_period   = lookup(var.cluster, "backup_retention_period", 30)
  preferred_backup_window   = lookup(var.cluster, "preferred_backup_window", "01:00-04:00")
  snapshot_identifier       = lookup(var.cluster, "snapshot_identifier", null)
  skip_final_snapshot       = lookup(var.cluster, "skip_final_snapshot", false)
  final_snapshot_identifier = lookup(var.cluster, "final_snapshot_identifier", var.name)

  // disk
  storage_encrypted = true
  kms_key_id        = module.disk_encryption.kms_key.arn

  // networking & firewalling
  port                 = lookup(var.cluster, "port", 17017)
  db_subnet_group_name = aws_docdb_subnet_group.this.id

  vpc_security_group_ids = concat(
    [module.firewall.security_group.id],
    lookup(var.cluster, "extra_security_group_ids", [])
  )

  // monitoring & logs
  enabled_cloudwatch_logs_exports = concat(
    lookup(var.cluster, "enabled_cloudwatch_logs_exports", []),
    ["audit"]
  )
}
