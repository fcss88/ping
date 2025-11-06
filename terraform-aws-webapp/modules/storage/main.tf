# modules/storage/main.tf
# Creates S3 bucket for static assets (images, CSS, JS, etc.)

# ============================================
# S3 Bucket for Static Assets
# ============================================
# S3 bucket names must be globally unique across ALL AWS accounts
resource "aws_s3_bucket" "static_assets" {
  bucket = "${var.project_name}-${var.environment}-static-${var.bucket_suffix}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-static-assets"
    Purpose     = "Static assets storage"
    Environment = var.environment
  }
}

# ============================================
# Bucket Versioning
# ============================================
# Keeps multiple versions of objects (useful for rollbacks)
resource "aws_s3_bucket_versioning" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# ============================================
# Server-Side Encryption
# ============================================
# Encrypt all objects stored in the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # AWS managed encryption
    }
  }
}

# ============================================
# Block Public Access
# ============================================
# Prevents accidental public exposure of data
# We'll use CloudFront or ALB to serve content instead
resource "aws_s3_bucket_public_access_block" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================
# Lifecycle Policy
# ============================================
# Automatically manage object lifecycle to reduce costs
resource "aws_s3_bucket_lifecycle_configuration" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  # Rule for transitioning old versions to cheaper storage
  rule {
    id     = "transition-old-versions"
    status = "Enabled"

    # Only apply to versioned objects
    filter {}

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA" # Infrequent Access (cheaper)
    }

    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER" # Even cheaper for archival
    }

    # Delete very old versions after 365 days
    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }

  # Rule for cleaning up incomplete multipart uploads
  rule {
    id     = "cleanup-incomplete-uploads"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# ============================================
# Bucket Policy for EC2 Access
# ============================================
# Allows EC2 instances with specific IAM role to read/write objects
resource "aws_s3_bucket_policy" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEC2Access"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.s3_access.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.static_assets.arn,
          "${aws_s3_bucket.static_assets.arn}/*"
        ]
      }
    ]
  })
}

# ============================================
# IAM Role for S3 Access
# ============================================
# This role will be attached to EC2 instances
resource "aws_iam_role" "s3_access" {
  name = "${var.project_name}-${var.environment}-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-s3-access-role"
  }
}

# IAM policy for S3 access
resource "aws_iam_role_policy" "s3_access" {
  name = "${var.project_name}-${var.environment}-s3-access-policy"
  role = aws_iam_role.s3_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.static_assets.arn,
          "${aws_s3_bucket.static_assets.arn}/*"
        ]
      }
    ]
  })
}

# Instance profile to attach the IAM role to EC2 instances
resource "aws_iam_instance_profile" "s3_access" {
  name = "${var.project_name}-${var.environment}-s3-access-profile"
  role = aws_iam_role.s3_access.name

  tags = {
    Name = "${var.project_name}-${var.environment}-s3-access-profile"
  }
}

# ============================================
# S3 Bucket for Application Logs (Optional)
# ============================================
# Separate bucket for storing application logs
resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-${var.environment}-logs-${var.bucket_suffix}"

  tags = {
    Name        = "${var.project_name}-${var.environment}-logs"
    Purpose     = "Application logs storage"
    Environment = var.environment
  }
}

# Encryption for logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access for logs bucket
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle policy for logs - automatically delete old logs
resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    filter {
      prefix = "application-logs/"
    }

    # Transition to cheaper storage after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Transition to Glacier after 90 days
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Delete logs after 180 days
    expiration {
      days = 180
    }
  }

  rule {
    id     = "expire-access-logs"
    status = "Enabled"

    filter {
      prefix = "access-logs/"
    }

    # Delete access logs after 30 days
    expiration {
      days = 30
    }
  }
}