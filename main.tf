locals {
  domain_name = var.create_wildcard ? "*.${var.domain_name}" : var.domain_name
}

resource "aws_acm_certificate" "this" {
  domain_name       = local.domain_name
  validation_method = "DNS"
  tags              = merge({ Name = var.git }, local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "this" {
  count           = var.enable_validation && length(var.alias) == 0 ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
  records         = [tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_value]
  ttl             = 60
  zone_id         = var.zone_id
}

resource "aws_route53_record" "alias" {
  count           = var.enable_validation && length(var.alias) > 0 ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
  zone_id         = var.zone_id
  alias {
    name                   = var.alias["name"]
    zone_id                = var.alias["zone_id"]
    evaluate_target_health = var.alias["evaluate_target_health"]
  }
}

resource "aws_acm_certificate_validation" "this" {
  count                   = var.enable_validation ? 1 : 0
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.this[0].fqdn]
}

resource "time_sleep" "this" {
  depends_on      = [aws_acm_certificate_validation.this]
  create_duration = var.enable_validation ? "${var.time_sleep}s" : "0s"
}
