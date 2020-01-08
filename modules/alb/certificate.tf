resource "aws_acm_certificate" "this" {
  domain_name       = var.dns.domain_name
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    { Name = var.dns.domain_name }
  )
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.this.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.this.domain_validation_options.0.resource_record_type
  zone_id = var.dns.zone_id
  records = [aws_acm_certificate.this.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
