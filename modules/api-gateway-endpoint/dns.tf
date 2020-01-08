resource "aws_api_gateway_domain_name" "this" {
  # types           = lookup(var.api, "api_types", ["EDGE"])
  certificate_arn = aws_acm_certificate_validation.this.certificate_arn
  domain_name     = var.api.dns_endpoint
  security_policy = lookup(var.api, "security_policy", "TLS_1_2")
}

resource "aws_route53_record" "api_dns_endpoint" {
  name    = aws_api_gateway_domain_name.this.domain_name
  type    = "A"
  zone_id = var.api.route_53_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.this.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.this.cloudfront_zone_id
  }
}
