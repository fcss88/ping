# outputs.tf
# Display important information after infrastructure is created

# ============================================
# Application Access Information
# ============================================

output "application_url" {
  description = "URL to access your application"
  value       = module.compute.application_url
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

# ============================================
# Networking Information
# ============================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.networking.private_subnet_ids
}

# ============================================
# Database Information
# ============================================

output "database_endpoint" {
  description = "Database connection endpoint"
  value       = module.database.db_instance_endpoint
  sensitive   = true
}

output "database_name" {
  description = "Name of the database"
  value       = module.database.db_name
}

output "database_port" {
  description = "Database port"
  value       = module.database.db_instance_port
}

# ============================================
# Storage Information
# ============================================

output "static_assets_bucket" {
  description = "S3 bucket name for static assets"
  value       = module.storage.static_assets_bucket_id
}

output "logs_bucket" {
  description = "S3 bucket name for logs"
  value       = module.storage.logs_bucket_id
}

# ============================================
# Auto Scaling Information
# ============================================

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.autoscaling_group_name
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = module.compute.launch_template_id
}

# ============================================
# Security Group IDs
# ============================================

output "alb_security_group_id" {
  description = "ID of ALB security group"
  value       = module.security.alb_security_group_id
}

output "web_security_group_id" {
  description = "ID of web server security group"
  value       = module.security.web_security_group_id
}

output "database_security_group_id" {
  description = "ID of database security group"
  value       = module.security.database_security_group_id
}

# ============================================
# Quick Start Commands
# ============================================

output "next_steps" {
  description = "Next steps to access and manage your infrastructure"
  value = <<-EOT
  
  ========================================
  🎉 Infrastructure Successfully Created!
  ========================================
  
  Your 3-tier web application is ready!
  
  📍 Access your application:
     ${module.compute.application_url}
  
  📊 Monitor your infrastructure:
     - EC2 Instances: https://console.aws.amazon.com/ec2/
     - Auto Scaling: https://console.aws.amazon.com/ec2/autoscaling/
     - RDS Database: https://console.aws.amazon.com/rds/
     - CloudWatch Logs: https://console.aws.amazon.com/cloudwatch/
  
  🔧 Useful AWS CLI commands:
     # Check Auto Scaling Group status
     aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${module.compute.autoscaling_group_name}
     
     # View ALB target health
     aws elbv2 describe-target-health --target-group-arn ${module.compute.target_group_arn}
     
     # Check RDS status
     aws rds describe-db-instances --db-instance-identifier ${module.database.db_instance_id}
     
     # List S3 buckets
     aws s3 ls s3://${module.storage.static_assets_bucket_id}
  
  📝 Important Notes:
     - Database credentials are stored in terraform.tfstate (keep it secure!)
     - Wait 5-10 minutes for instances to fully initialize
     - Check CloudWatch Logs for application logs
     - Default password should be changed in production
  
  🔒 Security Reminders:
     - Enable MFA on your AWS account
     - Rotate database credentials regularly
     - Enable AWS CloudTrail for audit logging
     - Review security group rules periodically
  
  ========================================
  EOT
}
