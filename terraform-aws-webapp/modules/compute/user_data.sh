#!/bin/bash
# user_data.sh
# This script runs automatically when an EC2 instance launches
# It installs and configures the web server and application

# Exit on any error
set -e

# Log everything to a file
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "=========================================="
echo "Starting user data script execution"
echo "=========================================="

# ============================================
# System Update
# ============================================
echo "Updating system packages..."
yum update -y

# ============================================
# Install Required Packages
# ============================================
echo "Installing web server and utilities..."
yum install -y \
    httpd \
    php \
    php-mysqlnd \
    php-fpm \
    mariadb105 \
    git \
    amazon-cloudwatch-agent \
    aws-cli

# ============================================
# Configure Apache Web Server
# ============================================
echo "Configuring Apache..."

# Enable and start Apache
systemctl enable httpd
systemctl start httpd

# Create a simple PHP info page for testing
cat > /var/www/html/index.php << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>${project_name} - ${environment}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 50px;
            background-color: #f0f0f0;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        h1 { color: #333; }
        .info { 
            background-color: #e8f5e9;
            padding: 15px;
            border-left: 4px solid #4caf50;
            margin: 20px 0;
        }
        .success { color: #4caf50; }
        .error { color: #f44336; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 ${project_name} Application - ${environment} Environment</h1>
        
        <div class="info">
            <h2>Server Information:</h2>
            <p><strong>Hostname:</strong> <?php echo gethostname(); ?></p>
            <p><strong>Server IP:</strong> <?php echo $_SERVER['SERVER_ADDR']; ?></p>
            <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
            <p><strong>Timestamp:</strong> <?php echo date('Y-m-d H:i:s'); ?></p>
        </div>

        <div class="info">
            <h2>Database Connection:</h2>
            <?php
            $host = "${db_endpoint}";
            $dbname = "${db_name}";
            $username = "${db_username}";
            $password = "${db_password}";

            try {
                // Extract host and port from endpoint
                list($db_host, $db_port) = explode(':', $host);
                
                $dsn = "mysql:host=$db_host;port=$db_port;dbname=$dbname";
                $pdo = new PDO($dsn, $username, $password);
                $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                
                echo '<p class="success">✅ Database connection successful!</p>';
                echo '<p>Connected to: ' . htmlspecialchars($host) . '</p>';
                
                // Test query
                $stmt = $pdo->query('SELECT VERSION() as version');
                $result = $stmt->fetch(PDO::FETCH_ASSOC);
                echo '<p>Database Version: ' . htmlspecialchars($result['version']) . '</p>';
                
            } catch(PDOException $e) {
                echo '<p class="error">❌ Database connection failed!</p>';
                echo '<p class="error">Error: ' . htmlspecialchars($e->getMessage()) . '</p>';
            }
            ?>
        </div>

        <div class="info">
            <h2>Load Balancer Health Check:</h2>
            <p class="success">✅ Instance is healthy and serving traffic</p>
        </div>
    </div>
</body>
</html>
EOF

# Set proper permissions
chown apache:apache /var/www/html/index.php
chmod 644 /var/www/html/index.php

# Create a simple health check endpoint
cat > /var/www/html/health.html << 'EOF'
OK
EOF

# ============================================
# Configure CloudWatch Agent
# ============================================
echo "Configuring CloudWatch Agent..."

# Create CloudWatch Agent configuration
cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json << 'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/aws/ec2/${project_name}-${environment}/apache/access",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 7
          },
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "/aws/ec2/${project_name}-${environment}/apache/error",
            "log_stream_name": "{instance_id}",
            "retention_in_days": 7
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "${project_name}-${environment}",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          {
            "name": "cpu_usage_idle",
            "rename": "CPU_IDLE",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          {
            "name": "used_percent",
            "rename": "DISK_USED",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          {
            "name": "mem_used_percent",
            "rename": "MEM_USED",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60
      }
    }
  }
}
EOF

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json

# ============================================
# System Optimization
# ============================================
echo "Optimizing system settings..."

# Increase file descriptors limit
cat >> /etc/security/limits.conf << 'EOF'
* soft nofile 65536
* hard nofile 65536
EOF

# Configure system parameters
cat >> /etc/sysctl.conf << 'EOF'
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.core.netdev_max_backlog = 5000
EOF
sysctl -p

# ============================================
# Security Hardening
# ============================================
echo "Applying security configurations..."

# Disable unnecessary services
systemctl disable postfix 2>/dev/null || true

# Configure firewall (firewalld)
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

# ============================================
# Completion
# ============================================
echo "=========================================="
echo "User data script completed successfully!"
echo "Web server is running and ready to serve traffic"
echo "=========================================="

# Send success signal
curl -X PUT -H 'Content-Type:' \
    --data-binary '{"Status": "SUCCESS", "Reason": "Configuration Complete", "UniqueId": "ID1234", "Data": "Application has completed configuration."}' \
    "${!AWS_CloudFormation_WaitConditionHandle}" 2>/dev/null || true
