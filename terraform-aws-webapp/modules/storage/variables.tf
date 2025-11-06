# modules/storage/variables.tf
# Variables for S3 storage module

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_suffix" {
  description = "Random suffix for bucket name uniqueness"
  type        = string
}
