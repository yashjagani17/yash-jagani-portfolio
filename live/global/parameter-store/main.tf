terraform {
  backend "s3" {
    bucket       = "yash-jagani-portfolio-terraform-state"
    key          = "global/parameter-store/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_ssm_parameter" "weather_app_stage" {
  name = "/weather-app/stage/api-key"
  description = "API key for the staging weather app"
  type = "SecureString"
  value = var.api_keys["stage"]
  overwrite = true
}

resource "aws_ssm_parameter" "weather_app_prod" {
  name = "/weather-app/prod/api-key"
  description = "API key for the production weather app"
  type = "SecureString"
  value = var.api_keys["prod"]
  overwrite = true
}