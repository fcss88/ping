# modules/database/variables.tf
# Variables for RDS database module

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "db_engine" {
  description = "Database engine (mysql or postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_name" {
  description = "Name of the default database"
  type        = string
}

variable "db_username" {
  description = "Master username for database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for database"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Days to retain backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window (UTC)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}