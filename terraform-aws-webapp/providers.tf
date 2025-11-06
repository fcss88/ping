# providers.tf
# Configure the AWS Provider and set default tags for all resources

provider "aws" {
  # AWS region where resources will be created
  region = var.aws_region

  # Default tags applied to all resources created by this configuration
  # This helps with cost tracking, resource management, and organization
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
      CreatedAt   = timestamp()
    }
  }
}

# Generate random suffix for unique resource names
# This prevents naming conflicts when creating multiple environments
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}