# modules/storage/outputs.tf
# Export S3 bucket information

output "static_assets_bucket_id" {
  description = "ID of the static assets S3 bucket"
  value       = aws_s3_bucket.static_assets.id
}

output "static_assets_bucket_arn" {
  description = "ARN of the static assets S3 bucket"
  value       = aws_s3_bucket.static_assets.arn
}

output "static_assets_bucket_domain_name" {
  description = "Domain name of the static assets S3 bucket"
  value       = aws_s3_bucket.static_assets.bucket_domain_name
}

output "static_assets_bucket_regional_domain_name" {
  description = "Regional domain name of the static assets S3 bucket"
  value       = aws_s3_bucket.static_assets.bucket_regional_domain_name
}

output "logs_bucket_id" {
  description = "ID of the logs S3 bucket"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "ARN of the logs S3 bucket"
  value       = aws_s3_bucket.logs.arn
}

output "s3_access_role_arn" {
  description = "ARN of the IAM role for S3 access"
  value       = aws_iam_role.s3_access.arn
}

output "s3_instance_profile_name" {
  description = "Name of the IAM instance profile for S3 access"
  value       = aws_iam_instance_profile.s3_access.name
}

output "s3_instance_profile_arn" {
  description = "ARN of the IAM instance profile for S3 access"
  value       = aws_iam_instance_profile.s3_access.arn
}