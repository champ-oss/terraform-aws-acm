output "arn" {
  description = "Certificate ARN"
  value       = var.enabled ? local.cert_arn : ""
}
