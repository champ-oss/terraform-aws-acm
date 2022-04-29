output "arn" {
  description = "Certificate ARN"
  value       = module.with_validation.arn
}

output "region" {
  description = "AWS Region"
  value       = data.aws_region.this.name
}