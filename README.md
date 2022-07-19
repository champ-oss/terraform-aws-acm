# terraform-module-template
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.71.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.71.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [time_sleep.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_wildcard"></a> [create\_wildcard](#input\_create\_wildcard) | Create a wildcard certificate (Ex: *.example.com | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate#domain_name | `string` | n/a | yes |
| <a name="input_enable_validation"></a> [enable\_validation](#input\_enable\_validation) | Enable ACM validation through Route 53 | `bool` | `true` | no |
| <a name="input_git"></a> [git](#input\_git) | Name of the Git repo | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to resources | `map(string)` | `{}` | no |
| <a name="input_time_sleep"></a> [time\_sleep](#input\_time\_sleep) | Seconds to wait for certificate validation | `number` | `30` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#zone_id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Certificate ARN |
<!-- END_TF_DOCS -->