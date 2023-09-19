locals {
  git = "terraform-aws-acm"
  tags = {
    git     = local.git
    cost    = "shared"
    creator = "terraform"
  }
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "public" {
  tags = {
    purpose = "vega"
    Type    = "Public"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

resource "aws_security_group" "this" {
  name_prefix = "terraform-aws-acm-"
  vpc_id      = data.aws_vpcs.this.ids[0]
  tags        = local.tags
}

resource "aws_lb" "this" {
  name_prefix     = "lb-pb-"
  security_groups = [aws_security_group.this.id]
  subnets         = data.aws_subnets.public.ids
  tags            = local.tags
  internal        = false
}

module "this" {
  source            = "../../"
  depends_on        = [aws_lb.this]
  git               = local.git
  domain_name       = "terraform-aws-acm.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  depends_on        = [aws_lb.this]
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = module.this.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No valid routing rule"
      status_code  = "400"
    }
  }
}

output "arn" {
  description = "Certificate ARN"
  value       = module.this.arn
}
