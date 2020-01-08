resource "aws_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  lifecycle {
    create_before_destroy = true
  }

  security_group_id        = aws_security_group.this.id
  type                     = "ingress"
  description              = lookup(each.value, "description", each.key)
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
}

resource "aws_security_group_rule" "egress" {
  for_each = var.egress_rules

  lifecycle {
    create_before_destroy = true
  }

  security_group_id = aws_security_group.this.id
  type              = "egress"
  description       = lookup(each.value, "description", each.key)
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_blocks       = each.value.cidr_blocks
}
