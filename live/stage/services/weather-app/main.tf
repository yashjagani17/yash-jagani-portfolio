provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket       = "yash-jagani-portfolio-terraform-state"
    key          = "stage/weather-app/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "yash-jagani-portfolio-terraform-state"
    key    = "global/iam/terraform.tfstate"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "parameter_store" {
  backend = "s3"
  config = {
    bucket = "yash-jagani-portfolio-terraform-state"
    key    = "global/parameter-store/terraform.tfstate"
    region = "eu-west-2"
  }
}

module "weather_app" {
  source = "git::https://github.com/yashjagani17/terraform-modules.git//services/weather-app?ref=weather-app-v1.0.1"

  project_name = "weather-app"
  project_env  = "stage"
  iam_role_arn = data.terraform_remote_state.iam.outputs.lambda_execution_role_arn
  api_key_path = data.terraform_remote_state.parameter_store.outputs.stage_path
  cors_origins = ["https://stage.yashjagani.com"]
}