provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket       = "yash-jagani-portfolio-terraform-state"
    key          = "global/dns/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

resource "aws_route53_zone" "root" {
  name = var.domain_name
}