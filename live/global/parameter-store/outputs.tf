output "stage_path" {
  description = "Path to the parameter store for the staging API key"
  value = aws_ssm_parameter.weather_app_stage.name
}

output "prod_path" {
  description = "Path to the parameter store for the production API key"
  value = aws_ssm_parameter.weather_app_prod.name
}