output "arn" {
  depends_on  = [time_sleep.this]
  description = "Certificate ARN"
  value       = aws_acm_certificate.this.arn
}

output "fqdn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#fqdn"
  value       = aws_route53_record.this.fqdn
}

output "arn_minus_sleep" {
  description = "Certificate ARN"
  value       = aws_acm_certificate.this.arn
}