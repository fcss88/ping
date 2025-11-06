# modules/networking/main.tf
# Creates VPC, subnets, internet gateway, NAT gateways, and route tables

# ============================================
# VPC - Virtual Private Cloud
# ============================================
# This is your isolated network in AWS where all resources will live
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Enables DNS hostnames for EC2 instances
  enable_dns_support   = true # Enables DNS resolution

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# ============================================
# Internet Gateway
# ============================================
# Allows resources in public subnets to access the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

# ============================================
# Public Subnets
# ============================================
# Subnets with direct internet access (for load balancers)
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true # Auto-assign public IPs to instances

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
    Type = "Public"
  }
}

# ============================================
# Private Subnets (for Application Servers)
# ============================================
# Subnets without direct internet access (more secure)
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
    Type = "Private"
  }
}

# ============================================
# Database Subnets
# ============================================
# Isolated subnets for database (extra security layer)
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-${var.environment}-database-subnet-${count.index + 1}"
    Type = "Database"
  }
}

# ============================================
# Elastic IPs for NAT Gateways
# ============================================
# Static public IP addresses for NAT gateways
resource "aws_eip" "nat" {
  count = length(var.availability_zones)

  domain = "vpc"
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
  }
}

# ============================================
# NAT Gateways
# ============================================
# Allows instances in private subnets to access internet (for updates, etc.)
# but prevents incoming connections from internet
resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-gw-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}

# ============================================
# Route Table for Public Subnets
# ============================================
# Directs internet traffic through Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # All traffic
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ============================================
# Route Tables for Private Subnets
# ============================================
# Each private subnet gets its own route table with NAT gateway
# This provides high availability - if one NAT fails, other subnets still work
resource "aws_route_table" "private" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-${count.index + 1}"
  }
}

# Associate private subnets with their route tables
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ============================================
# Route Table for Database Subnets
# ============================================
# Database subnets use same NAT gateways as private subnets
resource "aws_route_table_association" "database" {
  count = length(aws_subnet.database)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ============================================
# DB Subnet Group
# ============================================
# RDS requires a subnet group (collection of subnets for database)
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}
