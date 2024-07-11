locals {
  domain_name = var.create_wildcard ? "*.${var.domain_name}" : var.domain_name
}

resource "aws_acm_certificate" "this" {
  count             = var.enabled ? 1 : 0
  domain_name       = local.domain_name
  validation_method = "DNS"
  tags              = merge({ Name = var.git }, local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "this" {
  count           = var.enabled && var.enable_validation ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.this[0].domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.this[0].domain_validation_options)[0].resource_record_type
  records         = [tolist(aws_acm_certificate.this[0].domain_validation_options)[0].resource_record_value]
  ttl             = 60
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  count                   = var.enabled && var.enable_validation ? 1 : 0
  certificate_arn         = aws_acm_certificate.this[0].arn
  validation_record_fqdns = [aws_route53_record.this[0].fqdn]
}