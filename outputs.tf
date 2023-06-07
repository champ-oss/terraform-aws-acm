output "arn" {
  depends_on  = [time_sleep.this]
  description = "Certificate ARN"
  value       = aws_acm_certificate.this.arn
}
