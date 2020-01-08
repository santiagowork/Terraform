resource "aws_default_security_group" "this" {
  lifecycle {
    create_before_destroy = true
  }

  vpc_id = aws_vpc.this.id

  tags = merge(
    map("Name", "DON'T USE: ${var.name} blocked default security group"),
    var.common_tags
  )
}

resource "aws_default_network_acl" "this" {
  lifecycle {
    create_before_destroy = true
  }

  default_network_acl_id = aws_vpc.this.default_network_acl_id

  tags = merge(
    { Name = "DON'T USE: default ${var.name} blocked network ACL" },
    var.common_tags
  )
}
