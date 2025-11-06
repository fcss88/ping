# 🎯 Project Summary: AWS 3-Tier Web Application Infrastructure
## 📊 Overview
This is a complete, production-ready Terraform project that deploys a highly available 3-tier web application on AWS. Perfect for DevOps/SysAdmin portfolio!

### What's Included
- ✅ Core Infrastructure (9 files)
- ✅ main.tf - Root module orchestration
- ✅ variables.tf - 30+ configurable variables
- ✅ outputs.tf - 15+ useful outputs
- ✅ providers.tf - AWS provider configuration
- ✅ versions.tf - Version constraints
- ✅ terraform.tfvars.example - Example configuration
- ✅ .gitignore - Git ignore rules
- ✅ README.md - Complete documentation (2000+ lines)
- ✅ Makefile - Helper commands
- ✅ Modules (5 modules, 15 files)

1. Networking Module (3 files)
- VPC with customizable CIDR
- Public subnets (2 AZs) - for ALB
- Private subnets (2 AZs) - for EC2
- Database subnets (2 AZs) - for RDS
- Internet Gateway
- NAT Gateways (2 for HA)
- Route Tables
- DB Subnet Group

2. Security Module (3 files)
- ALB Security Group (HTTP/HTTPS from internet)
- Web Server Security Group (traffic from ALB only)
- Database Security Group (traffic from web servers only)
- VPC Endpoints Security Group

3. Compute Module (4 files)
- Application Load Balancer
- Target Group with health checks
- Launch Template with user data
- Auto Scaling Group (min/max/desired)
- Auto Scaling Policies (scale up/down)
- CloudWatch Alarms (CPU, response time, unhealthy targets)
- Latest Amazon Linux 2023 AMI detection

4. Database Module (3 files)
- RDS instance (MySQL or PostgreSQL)
- Parameter Group
- Multi-AZ option
- Automated backups
- Enhanced monitoring
- CloudWatch alarms (CPU, storage, connections)
- IAM role for monitoring

5. Storage Module (3 files)
- S3 bucket for static assets
- S3 bucket for logs
- Encryption enabled
- Versioning enabled
- Lifecycle policies
- IAM role for EC2