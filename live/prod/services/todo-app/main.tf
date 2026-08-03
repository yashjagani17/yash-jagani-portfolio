provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "yash-jagani-portfolio-terraform-state"
    key = "prod/weather-app/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    use_lockfile = true
  }
}