# AWS 3-Tier Web Application Infrastructure
###### Terraform 1.0+ | AWS Cloud | Licence MIT

A complete, production-ready Terraform configuration for deploying a highly available 3-tier web application on AWS.

### 🏗️ Architecture Overview
This infrastructure consists of three main tiers:

#### Tier 1: Presentation Layer (Public)
- Application Load Balancer (ALB)
- Distributes traffic across multiple availability zones
- SSL/TLS termination (when configured)
- Health checks and automatic failover
#### Tier 2: Application Layer (Private)
- Auto Scaling Group with EC2 instances
- Runs in private subnets for security
- Automatically scales based on CPU utilization
- Web server (Apache) with PHP
- CloudWatch agent for monitoring
#### Tier 3: Data Layer (Private)
- Amazon RDS (MySQL/PostgreSQL)
- Multi-AZ deployment option for high availability
- Automated backups and maintenance
- Encrypted at rest
- Supporting Infrastructure
- VPC with public and private subnets across 2 AZs
- NAT Gateways for outbound internet access
- Security Groups with least privilege access
- S3 buckets for static assets and logs
- CloudWatch alarms and monitoring
- IAM roles and policies

### 📋 Prerequisites
Before you begin, ensure you have:
- AWS Account with appropriate permissions
- AWS CLI installed and configured```aws configure```
- Terraform (version 1.0 or higher) 
```
   # Check version
   terraform version
```
- Basic knowledge of AWS services and Terraform

### 🚀 Quick Start
1. Clone the Repository

```git clone <your-repo-url>```

```cd terraform-aws-3tier-webapp```

2. Configure Variables

```
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your settings
nano terraform.tfvars
```
Important variables to set:
- aws_region - Your preferred AWS region
- project_name - Name of your project
- environment - dev, staging, or prod
- db_password - Strong database password (minimum 8 characters)
- owner - Your name or team name


3. Initialize Terraform

```
# Download required providers and modules
terraform init
```

4. Review the Plan

```
# See what will be created
terraform plan
```

5. Deploy Infrastructure

```
# Create all resources
terraform apply
# Type 'yes' when prompted
```

⏱️ Deployment takes approximately 10-15 minutes

6. Access Your Application
After deployment completes, Terraform will output the application URL:

```
application_url = "http://your-alb-dns-name.region.elb.amazonaws.com"
```

Visit this URL in your browser to see your application!


### 📁 Project Structure

```
terraform-aws-3tier-webapp/
├── main.tf                      # Main configuration
├── variables.tf                 # Variable definitions
├── outputs.tf                   # Output definitions
├── providers.tf                 # Provider configuration
├── versions.tf                  # Version constraints
├── terraform.tfvars.example     # Example variables
├── .gitignore                   # Git ignore rules
├── README.md                    # This file
│
└── modules/
    ├── networking/              # VPC, Subnets, NAT, IGW
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security/                # Security Groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── compute/                 # ALB, ASG, EC2
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── user_data.sh
    │
    ├── database/                # RDS
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── storage/                 # S3 Buckets
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```
### 🔧 Configuration Options
Instance Types (default): t3.micro (Free tier eligible)

##### For production, consider:
- t3.small - 2 vCPU, 2 GB RAM
- t3.medium - 2 vCPU, 4 GB RAM
- c5.large - Compute optimized
##### Database Options
- MySQL 8.0 (default) or PostgreSQL 15
- db.t3.micro - Free tier
- db.t3.small - Production ready
- Multi-AZ deployment for high availability
##### Auto Scaling
- min_size: Minimum instances (default: 2)
- max_size: Maximum instances (default: 4)
- desired_capacity: Target instances (default: 2)
##### Scales automatically based on CPU utilization:
- Scale UP when CPU > 70%
- Scale DOWN when CPU < 20%

### 📊 Monitoring & Logging
CloudWatch Dashboards

#### Monitor your infrastructure in CloudWatch:
- EC2 instance metrics
- ALB performance
- RDS database metrics
- Custom application metrics
- CloudWatch Alarms

##### Automatic alerts for:
- High CPU utilization
- Unhealthy targets
- Database connection issues
- High response times

### Application Logs
Logs are automatically sent to CloudWatch Logs:

- Apache access logs
- Apache error logs
- System logs

#### 🔒 Security Best Practices
✅ Implemented:

- Private subnets for application and database
- Security groups with least privilege
- Encrypted EBS volumes
- Encrypted S3 buckets
- Encrypted RDS database
- No public access to database
- IMDSv2 required for EC2 metadata

#### ⚠️ For Production, Also Enable:

- SSL/TLS certificates (HTTPS)
- AWS WAF for application firewall
- AWS GuardDuty for threat detection
- AWS CloudTrail for audit logging
- Secrets Manager for credentials
- MFA for AWS accounts
- VPC Flow Logs
- AWS Config for compliance

### 🛠️ Common Operations
#### Update Infrastructure
1. Make changes to .tf files or terraform.tfvars
2. Preview changes ```terraform plan``` 
3. Apply changes ```terraform apply``` 

### Scale Application
1. Edit terraform.tfvars ```desired_capacity = 4```
2. Apply changes ```terraform apply```
3. View Outputs ```terraform output```
4. View specific output ```terraform output application_url```


### SSH into EC2 Instance
1. Get instance ID from AWS Console or CLI
```aws ec2 describe-instances --filters "Name=tag:Project,Values=webapp"```

2. Use Systems Manager Session Manager (recommended)
```aws ssm start-session --target i-1234567890abcdef0```

3. Or use SSH (requires key pair and security group rule)
```ssh -i your-key.pem ec2-user@instance-ip```

### Check Application Health:
#### View target health
```
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)
```
#### View Auto Scaling Group status
```
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names $(terraform output -raw autoscaling_group_name)
```

### Database Connection

Get database endpoint ```terraform output database_endpoint```


#### Connect using MySQL client
```mysql -h your-db-endpoint -u admin -p```

 Or PostgreSQL client ```psql -h your-db-endpoint -U admin -d appdb```


### 💰 Cost Estimation
Approximate monthly costs (us-east-1 region):

Service	Configuration ---> Monthly Cost

- EC2 (2x t3.micro)	730 hours each $15.18
- RDS (db.t3.micro)	730 hours	$12.41
- Application Load Balancer	Standard	$16.20
- NAT Gateway (2x)	2 AZs	$64.62
- EBS Storage (40 GB)	gp3	$3.20
- S3 Storage	10 GB	$0.23
- Data Transfer	~10 GB out	$0.90

**Total ~$112.74/month**


#### Free Tier Benefits (first 12 months):
- 750 hours/month of t3.micro EC2
- 750 hours/month of db.t3.micro RDS
- 15 GB data transfer out

Note: *Actual costs may vary based on usage patterns*

### 🗑️ Cleanup
⚠️ WARNING: This will DELETE all resources!

- Destroy all infrastructure ```terraform destroy``` Type 'yes' when prompted

#### Alternatively, destroy specific resources:


#### Destroy only compute resources
```terraform destroy -target=module.compute```

#### Destroy only database
```terraform destroy -target=module.database```

### 🔄 Backup & Disaster Recovery

Automated Backups
- RDS: Automated daily backups (7-day retention)
- S3: Versioning enabled for all buckets
- EBS: Snapshots can be configured

#### Manual Backup
Create RDS snapshot

```
aws rds create-db-snapshot \
  --db-instance-identifier your-db-id \
  --db-snapshot-identifier manual-snapshot-$(date +%Y%m%d)
```

Create AMI from running instance
```
aws ec2 create-image \
  --instance-id i-1234567890abcdef0 \
  --name "backup-$(date +%Y%m%d)"
```

### Restore from Backup
#### Restore RDS from snapshot
```
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier restored-db \
  --db-snapshot-identifier snapshot-id
```

### 🐛 Troubleshooting
**Issue: "Error creating VPC"** Solution: Check AWS quota limits
```
aws service-quotas get-service-quota \
  --service-code vpc \
  --quota-code L-F678F1CE
```

**Issue: "No healthy targets"**

Possible causes:

- Security group blocking ALB → EC2 traffic
- Application not responding on port 80
- Health check path returning non-200 status

*Debug:*

Check security groups

SSH into instance and check:
```
sudo systemctl status httpd
curl localhost
```

**Issue: "Database connection failed"**

Possible causes:

- Security group blocking EC2 → RDS traffic
- Incorrect credentials
- Database not fully initialized
*Debug:*

- Test connectivity from EC2 ```telnet your-db-endpoint 3306```
-  Check RDS logs in CloudWatch

**Issue: "Terraform state locked"**

Solution: Force unlock (use carefully!) ```terraform force-unlock LOCK_ID```

### 📚 Additional Resources
- Terraform AWS Provider Documentation
- AWS Well-Architected Framework
- Terraform Best Practices
- AWS Free Tier

### 🤝 Contributing
Contributions are welcome! Please:

- Fork the repository
- Create a feature branch
- Make your changes
- Submit a pull request

### 📝 License
This project is licensed under the MIT License.

### 👨‍💻 Author
Created as a portfolio project to demonstrate DevOps/SysAdmin skills.

⭐ Acknowledgments

Built with:

- Terraform by HashiCorp
- AWS Cloud Services
- Open source community contributions
- Need help? Open an issue or contact the maintainer.


Found this useful? Give it a ⭐️ on GitHub!