# modules/compute/main.tf
# Creates Application Load Balancer, Launch Template, and Auto Scaling Group

# ============================================
# Data Source: Get Latest Amazon Linux 2023 AMI
# ============================================
# If no AMI ID is provided, use the latest Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ============================================
# Application Load Balancer (ALB)
# ============================================
# Distributes incoming traffic across multiple EC2 instances
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  # Enable deletion protection in production
  enable_deletion_protection = false

  # Enable access logs (optional - requires S3 bucket)
  # access_logs {
  #   bucket  = "your-logs-bucket"
  #   prefix  = "alb-logs"
  #   enabled = true
  # }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}

# ============================================
# ALB Target Group
# ============================================
# Defines how the ALB routes requests to registered targets (EC2 instances)
resource "aws_lb_target_group" "main" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Health check configuration
  health_check {
    enabled             = true
    healthy_threshold   = 2   # Number of successful checks before marking healthy
    unhealthy_threshold = 3   # Number of failed checks before marking unhealthy
    timeout             = 5   # Seconds to wait for response
    interval            = 30  # Seconds between health checks
    path                = "/" # Health check endpoint
    matcher             = "200" # Expected HTTP status code
  }

  # Deregistration delay - wait before removing target
  deregistration_delay = 30

  # Stickiness - route requests from same client to same target
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400 # 24 hours in seconds
    enabled         = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-target-group"
  }
}

# ============================================
# ALB Listener (HTTP)
# ============================================
# Listens for incoming HTTP traffic on port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  # Default action - forward to target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  # In production, add a redirect to HTTPS instead:
  # default_action {
  #   type = "redirect"
  #   redirect {
  #     port        = "443"
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
}

# ============================================
# ALB Listener (HTTPS) - Optional
# ============================================
# Uncomment this when you have an SSL certificate
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.main.arn
#   }
# }

# ============================================
# Launch Template
# ============================================
# Defines the configuration for EC2 instances
resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-${var.environment}-"
  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  # IAM instance profile for S3 access
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  # Security group
  vpc_security_group_ids = [var.web_security_group_id]

  # Enable detailed monitoring
  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  # User data script - runs on instance startup
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    project_name = var.project_name
    environment  = var.environment
    db_endpoint  = var.db_endpoint
    db_name      = var.db_name
    db_username  = var.db_username
    db_password  = var.db_password
  }))

  # Instance metadata options (security best practice)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Require IMDSv2
    http_put_response_hop_limit = 1
  }

  # EBS volume configuration
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20 # GB
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  # Tag specifications
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-web-instance"
      Environment = var.environment
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "${var.project_name}-${var.environment}-web-volume"
      Environment = var.environment
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-launch-template"
  }
}

# ============================================
# Auto Scaling Group
# ============================================
# Automatically manages the number of EC2 instances
resource "aws_autoscaling_group" "main" {
  name                = "${var.project_name}-${var.environment}-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.main.arn]

  # Capacity settings
  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  # Health check settings
  health_check_type         = "ELB" # Use ALB health checks
  health_check_grace_period = 300   # Wait 5 minutes before checking

  # Launch template
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  # Instance refresh settings (for updates)
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50 # Keep at least 50% healthy during updates
    }
  }

  # Wait for instances to be healthy before marking ASG as created
  wait_for_capacity_timeout = "10m"

  # Tags
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# ============================================
# Auto Scaling Policies
# ============================================

# Scale UP policy - add instances when CPU is high
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project_name}-${var.environment}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1 # Add 1 instance
  cooldown               = 300 # Wait 5 minutes before next scaling action
}

# Scale DOWN policy - remove instances when CPU is low
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project_name}-${var.environment}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1 # Remove 1 instance
  cooldown               = 300
}

# ============================================
# CloudWatch Alarms for Auto Scaling
# ============================================

# Alarm: High CPU - trigger scale up
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 70 # Scale up when CPU > 70%

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

# Alarm: Low CPU - trigger scale down
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20 # Scale down when CPU < 20%

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_description = "This metric monitors EC2 CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}

# ============================================
# CloudWatch Alarms for ALB Monitoring
# ============================================

# Alarm: Unhealthy targets
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  alarm_name          = "${var.project_name}-${var.environment}-unhealthy-targets"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
    TargetGroup  = aws_lb_target_group.main.arn_suffix
  }

  alarm_description = "Alert when targets become unhealthy"
}

# Alarm: High response time
resource "aws_cloudwatch_metric_alarm" "high_response_time" {
  alarm_name          = "${var.project_name}-${var.environment}-high-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 1 # 1 second

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_description = "Alert when response time is too high"
}
