# modules/database/outputs.tf
# Export database connection information

output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "db_instance_endpoint" {
  description = "Connection endpoint for the database"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "Hostname of the RDS instance"
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "Port the database is listening on"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Name of the default database"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Master username for the database"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "db_resource_id" {
  description = "Resource ID of the RDS instance"
  value       = aws_db_instance.main.resource_id
}