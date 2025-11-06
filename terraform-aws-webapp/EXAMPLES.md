# Usage Examples
This document provides practical examples for common use cases.

## 📋 Table of Contents
- Basic Deployment
- Production Deployment
- Multi-Environment Setup
- Custom Configurations
- Advanced Scenarios
- Basic Deployment
- Minimal Configuration (Free Tier)


#### terraform.tfvars
```
aws_region   = "us-east-1"
project_name = "myapp"
environment  = "dev"
```

#### Use free tier eligible resources
```
instance_type        = "t3.micro"
db_instance_class    = "db.t3.micro"
min_size             = 1
max_size             = 2
desired_capacity     = 1
db_multi_az          = false
```

#### Database credentials
```db_password = "YourSecurePassword123!"```

### Deploy:

```
terraform init
terraform apply
```

### Production Deployment
#### High Availability Setup

```
# terraform.tfvars
aws_region   = "us-east-1"
project_name = "myapp"
environment  = "prod"
owner        = "Platform-Team"
```

### Production-grade instances
```
instance_type        = "t3.medium"
db_instance_class    = "db.t3.large"
```

### High availability
```
min_size             = 4
max_size             = 10
desired_capacity     = 4
db_multi_az          = true
```

#### Enhanced monitoring
```
enable_detailed_monitoring = true
enable_s3_versioning      = true
```

#### Larger database
```db_allocated_storage = 100```


### Alerting
alarm_email = "ops@company.com"

### Strong password
```db_password = "SuperSecureProductionPassword123!@#"```

### Multi-Environment Setup
#### Directory Structure
```
terraform-aws-3tier-webapp/
├── environments/
│   ├── dev/
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── terraform.tfvars
│       └── backend.tf
└── modules/
```

### Development Environment

##### environments/dev/terraform.tfvars
```
aws_region         = "us-east-1"
project_name       = "myapp"
environment        = "dev"
instance_type      = "t3.micro"
min_size           = 1
max_size           = 2
desired_capacity   = 1
db_multi_az        = false
db_password        = "DevPassword123!"
Staging Environment
```
#### environments/staging/terraform.tfvars
```
aws_region         = "us-east-1"
project_name       = "myapp"
environment        = "staging"
instance_type      = "t3.small"
min_size           = 2
max_size           = 4
desired_capacity   = 2
db_multi_az        = true
db_password        = "StagingPassword123!"
Production Environment
```

#### environments/prod/terraform.tfvars
```
aws_region         = "us-east-1"
project_name       = "myapp"
environment        = "prod"
instance_type      = "t3.medium"
min_size           = 4
max_size           = 10
desired_capacity   = 4
db_multi_az        = true
enable_detailed_monitoring = true
db_password        = "ProductionPassword123!@#"
Deploy Specific Environment
```



### Deploy dev

```
cd environments/dev
terraform init
terraform apply
```

### Deploy staging
```
cd ../staging
terraform init
terraform apply
```

### Deploy prod
```
cd ../prod
terraform init
terraform apply
```

## Custom Configurations
### Custom VPC CIDR Ranges
#### terraform.tfvars
```
vpc_cidr              = "172.16.0.0/16"
public_subnet_cidrs   = ["172.16.1.0/24", "172.16.2.0/24"]
private_subnet_cidrs  = ["172.16.11.0/24", "172.16.12.0/24"]
database_subnet_cidrs = ["172.16.21.0/24", "172.16.22.0/24"]
```

### PostgreSQL Database


#### terraform.tfvars
```
db_engine         = "postgres"
db_engine_version = "15.3"
db_name           = "myappdb"
db_username       = "dbadmin"
db_password       = "SecurePostgresPassword123!"
```

### Different AWS Region
#### terraform.tfvars
```
aws_region         = "eu-west-1"
availability_zones = ["eu-west-1a", "eu-west-1b"]
```

### Larger Instance Types
#### terraform.tfvars
```
instance_type     = "c5.xlarge"  # Compute optimized
db_instance_class = "db.r5.large" # Memory optimized
```

## Advanced Scenarios
1. Using Existing VPC
Modify main.tf to use data sources:


```
# main.tf
data "aws_vpc" "existing" {
  id = "vpc-12345678"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
  
  tags = {
    Tier = "Private"
  }
}
```

Then pass to modules
```
module "compute" {
  source = "./modules/compute"
  
  vpc_id             = data.aws_vpc.existing.id
  private_subnet_ids = data.aws_subnets.private.ids
  # ... other variables
}
```

2. Using Remote State

```
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "myapp/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

Initialize with backend: ```terraform init -backend-config="bucket=my-state-bucket"```

3. Import Existing Resources
```
# Import existing VPC
terraform import module.networking.aws_vpc.main vpc-12345678

# Import existing RDS instance
terraform import module.database.aws_db_instance.main my-db-instance

# Import existing ALB
terraform import module.compute.aws_lb.main arn:aws:elasticloadbalancing:...
```


4. Workspace-Based Environments

```
# Create workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch workspace
terraform workspace select dev

# Deploy to current workspace
terraform apply -var-file="environments/${terraform.workspace}.tfvars"
```

5. Conditional Resources

```
# variables.tf
variable "enable_bastion" {
  description = "Enable bastion host for SSH access"
  type        = bool
  default     = false
}

# modules/compute/main.tf
resource "aws_instance" "bastion" {
  count = var.enable_bastion ? 1 : 0
  
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_ids[0]
  # ... other configuration
}
```

6. Custom User Data Script

```
# main.tf
module "compute" {
  source = "./modules/compute"
  
  user_data_template = templatefile("${path.module}/custom_user_data.sh", {
    custom_var = "value"
  })
  
  # ... other variables
}
```

7. Blue/Green Deployment

```
# Create new launch template version
terraform apply -target=module.compute.aws_launch_template.main

# Start instance refresh
aws autoscaling start-instance-refresh \
  --auto-scaling-group-name $(terraform output -raw autoscaling_group_name) \
  --preferences MinHealthyPercentage=50

# Monitor progress
aws autoscaling describe-instance-refreshes \
  --auto-scaling-group-name $(terraform output -raw autoscaling_group_name)

```

## Testing Examples

1. Test Application Endpoint

```
# Get ALB URL
APP_URL=$(terraform output -raw application_url)

# Test HTTP endpoint
curl -I $APP_URL

# Load test
ab -n 1000 -c 10 $APP_URL/
```

2. Test Database Connection

```
# Get DB endpoint
DB_ENDPOINT=$(terraform output -raw database_endpoint | cut -d: -f1)

# Test from EC2 instance
aws ssm start-session --target $(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=*web-instance*" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)

# Inside instance
mysql -h $DB_ENDPOINT -u admin -p
```

3. Test Auto Scaling

```
# Generate load
for i in {1..1000}; do
  curl $APP_URL > /dev/null 2>&1 &
done
```

## Watch instances scale
```
watch -n 5 'aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names $(terraform output -raw autoscaling_group_name) \
  --query "AutoScalingGroups[0].Instances[*].[InstanceId,HealthStatus,LifecycleState]" \
  --output table'
```

## Common Commands

```
# Show all outputs
terraform output

# Show specific output
terraform output application_url

# Refresh state
terraform refresh

# Taint resource (force recreate)
terraform taint module.compute.aws_launch_template.main

# Show resource details
terraform state show module.database.aws_db_instance.main

# List all resources
terraform state list

# Move resource in state
terraform state mv module.old module.new
```

## Troubleshooting Examples
### Check Resource Status

```
# EC2 instances
aws ec2 describe-instances \
  --filters "Name=tag:Project,Values=myapp" \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PrivateIpAddress]' \
  --output table

# ALB targets
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# RDS status
aws rds describe-db-instances \
  --db-instance-identifier $(terraform output -raw database_name) \
  --query 'DBInstances[0].[DBInstanceStatus,Endpoint.Address]'
```

## View Logs

```
# CloudWatch Logs
aws logs tail /aws/ec2/myapp-dev/apache/error --follow

# User data execution log
aws ssm send-command \
  --document-name "AWS-RunShellScript" \
  --targets "Key=tag:Project,Values=myapp" \
  --parameters 'commands=["cat /var/log/user-data.log"]'
```

For more examples, check the GitHub repository or open an issue!
