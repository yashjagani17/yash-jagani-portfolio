output "bucket_name" {
  value = aws_s3_bucket.website.id
  description = "S3 bucket name for the static website"
}