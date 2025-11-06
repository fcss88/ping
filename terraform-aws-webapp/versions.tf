# versions.tf
# This file specifies the required Terraform version and provider versions
# It ensures everyone working on this project uses compatible versions

terraform {
  # Require Terraform version 1.0 or higher
  required_version = ">= 1.0"

  # Define required providers and their versions
  required_providers {
    # AWS provider for managing AWS resources
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use AWS provider version 5.x (allows minor and patch updates)
    }

    # Random provider for generating random strings (useful for unique names)
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Optional: Configure remote state backend (uncomment when ready)
  # This stores your Terraform state file in S3 for team collaboration
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "3tier-webapp/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}