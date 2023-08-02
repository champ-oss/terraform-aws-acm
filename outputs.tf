output "arn" {
  description = "Certificate ARN"
  value       = var.enable_validation ? aws_acm_certificate_validation.this.certificate_arn : aws_acm_certificate.this.arn
}
