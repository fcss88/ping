# Makefile for Terraform AWS 3-Tier Infrastructure
# Provides convenient shortcuts for common operations

.PHONY: help init plan apply destroy validate fmt clean check-aws cost

# Default target
help:
	@echo "Available commands:"
	@echo "  make init        - Initialize Terraform"
	@echo "  make plan        - Show execution plan"
	@echo "  make apply       - Apply infrastructure changes"
	@echo "  make destroy     - Destroy all infrastructure"
	@echo "  make validate    - Validate Terraform files"
	@echo "  make fmt         - Format Terraform files"
	@echo "  make clean       - Clean Terraform cache"
	@echo "  make check-aws   - Check AWS credentials"
	@echo "  make cost        - Estimate infrastructure costs"
	@echo "  make outputs     - Show Terraform outputs"
	@echo "  make ssh         - SSH into EC2 instance"
	@echo "  make logs        - View CloudWatch logs"

# Check if AWS credentials are configured
check-aws:
	@echo "Checking AWS credentials..."
	@aws sts get-caller-identity || (echo "Error: AWS credentials not configured" && exit 1)
	@echo "✓ AWS credentials are valid"

# Initialize Terraform
init: check-aws
	@echo "Initializing Terraform..."
	terraform init
	@echo "✓ Terraform initialized"

# Validate Terraform configuration
validate:
	@echo "Validating Terraform configuration..."
	terraform validate
	@echo "✓ Configuration is valid"

# Format Terraform files
fmt:
	@echo "Formatting Terraform files..."
	terraform fmt -recursive
	@echo "✓ Files formatted"

# Show execution plan
plan: validate
	@echo "Creating execution plan..."
	terraform plan

# Apply infrastructure changes
apply: validate
	@echo "Applying infrastructure changes..."
	@echo "⚠️  This will create real AWS resources and incur costs!"
	@read -p "Continue? [y/N]: " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		terraform apply; \
	else \
		echo "Cancelled."; \
	fi

# Quick apply without confirmation (use carefully!)
apply-auto:
	terraform apply -auto-approve

# Destroy all infrastructure
destroy:
	@echo "⚠️  WARNING: This will DESTROY all infrastructure!"
	@read -p "Are you sure? Type 'destroy' to confirm: " confirm; \
	if [ "$$confirm" = "destroy" ]; then \
		terraform destroy; \
	else \
		echo "Cancelled."; \
	fi

# Clean Terraform cache and state files
clean:
	@echo "Cleaning Terraform cache..."
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	@echo "✓ Cache cleaned"
	@echo "Note: terraform.tfstate files were not deleted"

# Show Terraform outputs
outputs:
	@terraform output

# Get application URL
url:
	@terraform output -raw application_url 2>/dev/null || echo "Infrastructure not deployed yet"

# Estimate costs (requires infracost)
cost:
	@if command -v infracost >/dev/null 2>&1; then \
		infracost breakdown --path .; \
	else \
		echo "infracost not installed. Install from: https://www.infracost.io/docs/"; \
	fi

# SSH into EC2 instance (requires AWS Session Manager)
ssh:
	@echo "Getting instance ID..."
	@INSTANCE_ID=$$(aws ec2 describe-instances \
		--filters "Name=tag:Project,Values=$$(terraform output -raw project_name 2>/dev/null)" \
		--query 'Reservations[0].Instances[0].InstanceId' \
		--output text); \
	if [ "$$INSTANCE_ID" != "None" ] && [ -n "$$INSTANCE_ID" ]; then \
		echo "Connecting to instance $$INSTANCE_ID..."; \
		aws ssm start-session --target $$INSTANCE_ID; \
	else \
		echo "No running instances found"; \
	fi

# View CloudWatch logs
logs:
	@echo "Fetching recent logs..."
	@aws logs tail /aws/ec2/$$(terraform output -raw project_name 2>/dev/null)-$$(terraform output -raw environment 2>/dev/null)/apache/access --follow

# Show infrastructure status
status:
	@echo "=== Infrastructure Status ==="
	@echo ""
	@echo "VPC ID: $$(terraform output -raw vpc_id 2>/dev/null || echo 'N/A')"
	@echo "Application URL: $$(terraform output -raw application_url 2>/dev/null || echo 'N/A')"
	@echo ""
	@echo "=== Auto Scaling Group ==="
	@ASG_NAME=$$(terraform output -raw autoscaling_group_name 2>/dev/null); \
	if [ -n "$$ASG_NAME" ]; then \
		aws autoscaling describe-auto-scaling-groups \
			--auto-scaling-group-names $$ASG_NAME \
			--query 'AutoScalingGroups[0].[MinSize,DesiredCapacity,MaxSize,Instances[*].HealthStatus]' \
			--output table; \
	else \
		echo "Not deployed"; \
	fi

# Run pre-commit checks
check: validate fmt
	@echo "Running pre-commit checks..."
	@terraform fmt -check -recursive
	@echo "✓ All checks passed"

# Create a backup of state file
backup-state:
	@if [ -f terraform.tfstate ]; then \
		cp terraform.tfstate terraform.tfstate.backup.$$(date +%Y%m%d_%H%M%S); \
		echo "✓ State file backed up"; \
	else \
		echo "No state file to backup"; \
	fi