resource "aws_docdb_cluster_instance" "this" {
  for_each = var.db_instances

  identifier                   = "${var.name}-${each.key}"
  cluster_identifier           = aws_docdb_cluster.this.id
  apply_immediately            = lookup(each.value, "apply_immediately", false)
  auto_minor_version_upgrade   = lookup(each.value, "auto_minor_version_upgrade", true)
  availability_zone            = each.value.availability_zone
  instance_class               = each.value.instance_class
  preferred_maintenance_window = lookup(each.value, "preferred_maintenance_window", null)
  promotion_tier               = lookup(each.value, "promotion_tier", 0)

  tags = merge(
    var.common_tags,
    { Name = "${var.name}-${each.key}" }
  )
}
