resource "aws_acm_certificate" "this" {
  domain_name       = var.api.dns_endpoint
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    { Name = var.api.dns_endpoint }
  )
}

resource "aws_route53_record" "cert_validation" {
  zone_id = var.api.route_53_zone_id
  name    = aws_acm_certificate.this.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.this.domain_validation_options.0.resource_record_type
  records = [aws_acm_certificate.this.domain_validation_options.0.resource_record_value]
  ttl     = lookup(var.api, "certificate_dns_validation_ttl", 60)
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
