resource "aws_lb" "this" {
  name                             = var.name
  load_balancer_type               = "application"
  subnets                          = var.lb.subnets
  internal                         = lookup(var.lb, "internal", false)
  enable_cross_zone_load_balancing = lookup(var.lb, "enable_cross_zone_load_balancing", true)

  security_groups = concat(
    [module.firewall.security_group.id],
    lookup(var.lb, "extra_security_group_ids", [])
  )

  tags = merge(
    var.common_tags,
    { Name = var.name }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  protocol          = "HTTPS"
  port              = lookup(var.lb, "https_port", 443)
  ssl_policy        = lookup(var.lb, "ssl_policy", "ELBSecurityPolicy-TLS-1-2-2017-01")
  certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = jsonencode({ error = "access denied" })
      status_code  = 403
    }
  }
}

resource "aws_lb_listener_certificate" "extra_certificates" {
  for_each = var.dns.enabled ? toset(lookup(var.dns, "extra_domain_names", [])) : []

  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate.extra_domains[each.key].arn
}
