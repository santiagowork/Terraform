resource "aws_network_acl" "this" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_id     = var.vpc.id
  subnet_ids = values(aws_subnet.this).*.id

  tags = merge(
    { Name = var.name },
    var.common_tags
  )
}

resource "aws_network_acl_rule" "ingress" {
  for_each = var.network_acl_ingress_rules

  network_acl_id = aws_network_acl.this.id
  egress         = false
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = lookup(each.value, "from_port", null)
  to_port        = lookup(each.value, "to_port", null)
}

resource "aws_network_acl_rule" "egress" {
  for_each = var.network_acl_ingress_rules

  network_acl_id = aws_network_acl.this.id
  egress         = true
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = lookup(each.value, "from_port", null)
  to_port        = lookup(each.value, "to_port", null)
}
