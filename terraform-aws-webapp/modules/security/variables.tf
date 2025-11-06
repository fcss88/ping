# modules/security/variables.tf
# Variables for security groups module

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC (for internal traffic rules)"
  type        = string
}


