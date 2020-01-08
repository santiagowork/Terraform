resource "aws_route53_record" "lb" {
  count = var.dns.enabled ? 1 : 0

  name    = var.dns.domain_name
  type    = "A"
  zone_id = var.dns.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}

resource "aws_route53_record" "extra_domains" {
  for_each = var.dns.enabled ? toset(lookup(var.dns, "extra_domain_names", [])) : []

  name    = each.key
  type    = "A"
  zone_id = var.dns.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
  }
}
