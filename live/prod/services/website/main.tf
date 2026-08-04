provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "yash-jagani-portfolio-terraform-state"
    key          = "prod/website/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

data "aws_route53_zone" "root" {
  name = "yashjagani.com"
}

module "static_website" {
  source = "git::https://github.com/yashjagani17/terraform-modules.git//services/static-website?ref=v1.0.0"
  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
  project_env    = "prod"
  project_name   = "website"
  domain_name    = "yashjagani.com"
  hosted_zone_id = data.aws_route53_zone.root.zone_id
}