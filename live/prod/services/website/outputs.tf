output "bucket_name" {
  value       = module.static_website.bucket_name
  description = "S3 bucket name for the static website"
}