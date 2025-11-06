# modules/database/main.tf
# Creates RDS database instance with proper configuration

# ============================================
# RDS Parameter Group
# ============================================
# Parameter group defines database configuration settings
# Different settings for MySQL and PostgreSQL
resource "aws_db_parameter_group" "main" {
  name   = "${var.project_name}-${var.environment}-${var.db_engine}-params"
  family = var.db_engine == "mysql" ? "mysql8.0" : "postgres15"

  # Example parameters - customize based on your needs
  dynamic "parameter" {
    for_each = var.db_engine == "mysql" ? [
      { name = "max_connections", value = "100" },
      { name = "slow_query_log", value = "1" },
    ] : []
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-db-params"
  }
}

# ============================================
# RDS Instance
# ============================================
# This is the actual database server
resource "aws_db_instance" "main" {
  # Basic Configuration
  identifier     = "${var.project_name}-${var.environment}-db"
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  # Database Configuration
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Storage Configuration
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_allocated_storage * 2 # Auto-scaling up to 2x
  storage_type          = "gp3"                        # General Purpose SSD (latest generation)
  storage_encrypted     = true                         # Encrypt data at rest

  # High Availability
  multi_az               = var.db_multi_az # Deploy in multiple availability zones
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  # Backup Configuration
  backup_retention_period   = var.backup_retention_period    # Keep backups for N days
  backup_window             = var.preferred_backup_window    # When to run backups
  maintenance_window        = var.preferred_maintenance_window
  copy_tags_to_snapshot     = true # Copy tags to snapshots
  skip_final_snapshot       = true # Set to false in production!
  final_snapshot_identifier = "${var.project_name}-${var.environment}-db-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Monitoring and Logging
  enabled_cloudwatch_logs_exports = var.db_engine == "mysql" ? ["error", "general", "slowquery"] : ["postgresql"]
  monitoring_interval             = 60 # Enhanced monitoring every 60 seconds
  monitoring_role_arn             = aws_iam_role.rds_monitoring.arn

  # Performance and Maintenance
  auto_minor_version_upgrade = true          # Automatically apply minor version updates
  parameter_group_name       = aws_db_parameter_group.main.name
  publicly_accessible        = false         # Never expose DB to internet!
  deletion_protection        = false         # Set to true in production!

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }

  # Ensure proper order of resource creation
  depends_on = [aws_iam_role_policy_attachment.rds_monitoring]
}

# ============================================
# IAM Role for RDS Enhanced Monitoring
# ============================================
# This allows RDS to send metrics to CloudWatch
resource "aws_iam_role" "rds_monitoring" {
  name = "${var.project_name}-${var.environment}-rds-monitoring-role"

  # Trust policy - allows RDS to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-monitoring-role"
  }
}

# Attach AWS managed policy for RDS enhanced monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# ============================================
# CloudWatch Alarms for Database Monitoring
# ============================================

# Alarm for high CPU usage
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-db-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 80 # Alert if CPU > 80%
  alarm_description   = "This metric monitors RDS CPU utilization"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-db-cpu-alarm"
  }
}

# Alarm for low free storage space
resource "aws_cloudwatch_metric_alarm" "database_storage" {
  alarm_name          = "${var.project_name}-${var.environment}-db-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5000000000 # 5GB in bytes
  alarm_description   = "This metric monitors RDS free storage space"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-db-storage-alarm"
  }
}

# Alarm for high number of database connections
resource "aws_cloudwatch_metric_alarm" "database_connections" {
  alarm_name          = "${var.project_name}-${var.environment}-db-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80 # Adjust based on your max_connections setting
  alarm_description   = "This metric monitors RDS database connections"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-db-connections-alarm"
  }
}