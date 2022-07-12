provider "aws" {
  region = "us-east-1"
}

data "aws_region" "this" {}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

locals {
  git = "terraform-aws-acm"
  tags = {
    git     = local.git
    cost    = "shared"
    creator = "terraform"
  }
}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc?ref=v1.0.25-757a401"
  git                      = local.git
  availability_zones_count = 2
  retention_in_days        = 1
  create_private_subnets   = false
}

module "with_validation" {
  source            = "../../"
  depends_on        = [aws_lb.this]
  git               = local.git
  domain_name       = "terraform-aws-acm.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "no_validation" {
  source            = "../../"
  depends_on        = [aws_lb.this]
  git               = local.git
  domain_name       = data.aws_route53_zone.this.name
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = false
}

resource "aws_security_group" "this" {
  name_prefix = "terraform-aws-acm-"
  vpc_id      = module.vpc.vpc_id
  tags        = local.tags
}

resource "aws_lb" "this" {
  name_prefix     = "lb-pb-"
  security_groups = [aws_security_group.this.id]
  subnets         = module.vpc.public_subnets_ids
  tags            = local.tags
  internal        = false
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  depends_on        = [aws_lb.this]
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = module.with_validation.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No valid routing rule"
      status_code  = "400"
    }
  }
}
