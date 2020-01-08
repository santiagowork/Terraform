resource "aws_acm_certificate" "extra_domains" {
  for_each = var.dns.enabled ? toset(lookup(var.dns, "extra_domain_names", [])) : []

  domain_name       = each.key
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    { Name = each.key }
  )
}

resource "aws_route53_record" "extra_domains_cert_validation" {
  for_each = var.dns.enabled ? toset(lookup(var.dns, "extra_domain_names", [])) : []

  name    = aws_acm_certificate.extra_domains[each.key].domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.extra_domains[each.key].domain_validation_options.0.resource_record_type
  zone_id = var.dns.zone_id
  records = [aws_acm_certificate.extra_domains[each.key].domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "extra_domains" {
  for_each = var.dns.enabled ? toset(lookup(var.dns, "extra_domain_names", [])) : []

  certificate_arn         = aws_acm_certificate.extra_domains[each.key].arn
  validation_record_fqdns = [aws_route53_record.extra_domains_cert_validation[each.key].fqdn]
}
