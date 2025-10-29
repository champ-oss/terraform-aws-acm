output "arn" {
  description = "Certificate arn"
  value       = var.enable_validation ? try(aws_acm_certificate_validation.this[0].certificate_arn, "") : try(aws_acm_certificate.this[0].arn, "")
}

output "domain_name" {
  description = "Certificate domain name"
  value       = try(aws_acm_certificate.this[0].domain_name, "")
}