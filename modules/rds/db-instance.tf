resource "aws_db_instance" "this" {
  // Naming
  name       = var.rds.database_name
  identifier = var.name

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )

  // Database engine
  engine         = var.rds.engine
  engine_version = var.rds.engine_version

  // Sizing
  instance_class        = var.rds.instance_class
  storage_type          = lookup(var.rds, "storage_type", "gp2")
  allocated_storage     = lookup(var.rds, "allocated_storage", 20)
  max_allocated_storage = lookup(var.rds, "max_allocated_storage", null)
  storage_encrypted     = true
  kms_key_id            = module.disk_encryption.kms_key.arn
  iops                  = lookup(var.rds, "iops", null)

  // Baseline configuration
  parameter_group_name      = aws_db_parameter_group.this.name
  deletion_protection       = lookup(var.rds, "delete_protection", true)
  final_snapshot_identifier = lookup(var.rds, "final_snapshot_identifier", var.name)
  multi_az                  = lookup(var.rds, "multi_az", true)
  skip_final_snapshot       = lookup(var.rds, "skip_final_snapshot", false)
  // option_group_name - (Optional) Name of the DB option group to associate.
  // replicate_source_db - (Optional) Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate. Note that if you are creating a cross-region replica of an encrypted database you will also need to specify a kms_key_id. See DB Instance Replication and Working with PostgreSQL and MySQL Read Replicas for more information on using Replication.

  // Operations
  maintenance_window          = lookup(var.rds, "maintenance_window", "Sat:00:00-Sat:01:00")
  apply_immediately           = lookup(var.rds, "apply_immediately", false)
  allow_major_version_upgrade = lookup(var.rds, "allow_major_version_upgrade", false)
  auto_minor_version_upgrade  = lookup(var.rds, "auto_minor_version_upgrade", true)

  // Backup
  backup_window           = lookup(var.rds, "backup_window", "01:00-05:00")
  backup_retention_period = lookup(var.rds, "backup_retention_period", 7)
  copy_tags_to_snapshot   = lookup(var.rds, "copy_tags_to_snapshot", true)
  snapshot_identifier     = lookup(var.rds, "snapshot_id", null)

  // Authentication
  username = var.rds.username
  password = aws_secretsmanager_secret_version.password.secret_string
  // domain - (Optional) The ID of the Directory Service Active Directory domain to create the instance in.
  // domain_iam_role_name - (Optional, but required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service.
  // iam_database_authentication_enabled - (Optional) Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled.

  // Networking
  db_subnet_group_name = aws_db_subnet_group.this.name
  port                 = var.rds.port
  publicly_accessible  = lookup(var.rds, "publicly_accessible", false)

  vpc_security_group_ids = concat(
    [module.firewall.security_group.id],
    lookup(var.rds, "extra_security_groups", [])
  )

  // Monitoring & Logs
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  // monitoring_interval - (Optional) The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60.
  // monitoring_role_arn - (Optional) The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. You can find more information on the AWS Documentation what IAM permissions are needed to allow Enhanced Monitoring for RDS Instances.
  // performance_insights_enabled - (Optional) Specifies whether Performance Insights are enabled. Defaults to false.
  // performance_insights_kms_key_id - (Optional) The ARN for the KMS key to encrypt Performance Insights data. When specifying performance_insights_kms_key_id, performance_insights_enabled needs to be set to true. Once KMS key is set, it can never be changed.
  // performance_insights_retention_period - (Optional) The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years). When specifying performance_insights_retention_period, performance_insights_enabled needs to be set to true. Defaults to '7'.
}
