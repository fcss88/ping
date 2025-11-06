# variables.tf
# Define all input variables for the infrastructure
# Variables allow you to customize the deployment without changing the code

# ============================================
# General Configuration
# ============================================

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project (used for resource naming and tagging)"
  type        = string
  default     = "webapp"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "owner" {
  description = "Owner of the infrastructure (your name or team name)"
  type        = string
  default     = "DevOps-Team"
}

# ============================================
# Networking Configuration
# ============================================

variable "vpc_cidr" {
  description = "CIDR block for VPC (defines the IP range for your network)"
  type        = string
  default     = "10.0.0.0/16" # Allows 65,536 IP addresses
}

variable "availability_zones" {
  description = "List of availability zones to use for high availability"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (accessible from internet)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] # 256 IPs each
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (for app servers)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets (isolated for RDS)"
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

# ============================================
# Compute Configuration
# ============================================

variable "instance_type" {
  description = "EC2 instance type for application servers"
  type        = string
  default     = "t3.micro" # Free tier eligible, 2 vCPU, 1GB RAM
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (leave empty to use latest Amazon Linux 2023)"
  type        = string
  default     = "" # Will be auto-detected if empty
}

variable "min_size" {
  description = "Minimum number of EC2 instances in Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in Auto Scaling Group"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in Auto Scaling Group"
  type        = number
  default     = 2
}

# ============================================
# Database Configuration
# ============================================

variable "db_engine" {
  description = "Database engine (mysql or postgres)"
  type        = string
  default     = "mysql"
  
  validation {
    condition     = contains(["mysql", "postgres"], var.db_engine)
    error_message = "Database engine must be mysql or postgres."
  }
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0" # MySQL 8.0
}

variable "db_instance_class" {
  description = "RDS instance class (size of the database server)"
  type        = string
  default     = "db.t3.micro" # Free tier eligible
}

variable "db_name" {
  description = "Name of the default database to create"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for database"
  type        = string
  default     = "admin"
  sensitive   = true # Won't be displayed in logs
}

variable "db_password" {
  description = "Master password for database (minimum 8 characters)"
  type        = string
  sensitive   = true # Won't be displayed in logs
  
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20 # Minimum for free tier
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = false # Set to true for production
}

# ============================================
# Storage Configuration
# ============================================

variable "enable_s3_versioning" {
  description = "Enable versioning for S3 bucket (keeps old versions of files)"
  type        = bool
  default     = true
}

# ============================================
# Monitoring Configuration
# ============================================

variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring (costs extra)"
  type        = bool
  default     = false # Set to true for production
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarms (leave empty to disable)"
  type        = string
  default     = ""
}