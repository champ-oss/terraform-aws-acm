output "arn" {
  description = "Certificate ARN"
  value       = var.enable_validation ? try(aws_acm_certificate_validation.this[0].certificate_arn, "") : try(aws_acm_certificate.this[0].arn, "")
}
