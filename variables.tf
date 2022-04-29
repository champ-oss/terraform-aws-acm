locals {
  tags = {
    git     = var.git
    cost    = "shared"
    creator = "terraform"
  }
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "domain_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate#domain_name"
  type        = string
}

variable "zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#zone_id"
  type        = string
  default     = ""
}

variable "enable_validation" {
  description = "Enable ACM validation through Route 53"
  type        = bool
  default     = true
}

variable "create_wildcard" {
  description = "Create a wildcard certificate (Ex: *.example.com"
  type        = bool
  default     = true
}

variable "time_sleep" {
  description = "Seconds to wait for certificate validation"
  type        = number
  default     = 30
}