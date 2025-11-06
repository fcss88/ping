# main.tf
# Root module that ties all infrastructure components together

# ============================================
# Networking Module
# ============================================
# Creates VPC, subnets, NAT gateways, and route tables
module "networking" {
  source = "./modules/networking"

  project_name           = var.project_name
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  availability_zones     = var.availability_zones
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  database_subnet_cidrs  = var.database_subnet_cidrs
}

# ============================================
# Security Module
# ============================================
# Creates security groups for ALB, EC2, and RDS
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  vpc_cidr     = module.networking.vpc_cidr

  depends_on = [module.networking]
}

# ============================================
# Storage Module
# ============================================
# Creates S3 buckets for static assets and logs
module "storage" {
  source = "./modules/storage"

  project_name         = var.project_name
  environment          = var.environment
  enable_versioning    = var.enable_s3_versioning
  bucket_suffix        = random_string.suffix.result
}

# ============================================
# Database Module
# ============================================
# Creates RDS database instance
module "database" {
  source = "./modules/database"

  project_name              = var.project_name
  environment               = var.environment
  db_engine                 = var.db_engine
  db_engine_version         = var.db_engine_version
  db_instance_class         = var.db_instance_class
  db_name                   = var.db_name
  db_username               = var.db_username
  db_password               = var.db_password
  db_allocated_storage      = var.db_allocated_storage
  db_multi_az               = var.db_multi_az
  db_subnet_group_name      = module.networking.db_subnet_group_name
  vpc_security_group_ids    = [module.security.database_security_group_id]

  depends_on = [module.networking, module.security]
}

# ============================================
# Compute Module
# ============================================
# Creates ALB, Launch Template, and Auto Scaling Group
module "compute" {
  source = "./modules/compute"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  public_subnet_ids         = module.networking.public_subnet_ids
  private_subnet_ids        = module.networking.private_subnet_ids
  alb_security_group_id     = module.security.alb_security_group_id
  web_security_group_id     = module.security.web_security_group_id
  instance_type             = var.instance_type
  ami_id                    = var.ami_id
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  iam_instance_profile      = module.storage.s3_instance_profile_name
  enable_detailed_monitoring = var.enable_detailed_monitoring
  
  # Database connection info for application
  db_endpoint  = module.database.db_instance_endpoint
  db_name      = var.db_name
  db_username  = var.db_username
  db_password  = var.db_password

  depends_on = [
    module.networking,
    module.security,
    module.storage,
    module.database
  ]
}
