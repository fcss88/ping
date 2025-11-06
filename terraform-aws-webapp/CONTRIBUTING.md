# Contributing to AWS 3-Tier Infrastructure
*Thank you for your interest in contributing! This document provides guidelines for contributing to this project.*

## 🚀 Getting Started
Fork the repository

Clone your fork
```
   git clone https://github.com/fcss88/ping.git
   cd terraform-aws-3tier-webapp
```
### Create a feature branch

```
   git checkout -b feature/your-feature-name
   ```

### 📝 Code Standards
- Terraform Style Guide
- File Organization
- Use lowercase filenames with underscores
- Group related resources in the same file
- Keep modules focused and single-purpose

## Naming Conventions

```
   # Resources: use descriptive names
   resource "aws_instance" "web_server" { }
   
   # Variables: use snake_case
   variable "instance_type" { }
   
   # Outputs: use descriptive names
   output "alb_dns_name" { }
```

### Formatting

```
   # Always format before committing
   terraform fmt -recursive
```

### Comments
- Add comments for complex logic
- Explain WHY, not WHAT
- Use section headers for organization

```
   # ============================================
   # Section Name
   # ============================================
```

### Variables
- Always provide descriptions
- Set sensible defaults when possible
- Use validation rules
- Mark sensitive variables

```
   variable "db_password" {
     description = "Master password for database"
     type        = string
     sensitive   = true
     
     validation {
       condition     = length(var.db_password) >= 8
       error_message = "Password must be at least 8 characters."
     }
   }
```
## Best Practices
- Security
- Never commit secrets or credentials
- Use AWS Secrets Manager for sensitive data
- Enable encryption by default
- Follow least privilege principle
- High Availability
- Deploy across multiple AZs
- Use Auto Scaling Groups
- Implement health checks
- Cost Optimization
- Use appropriate instance types
- Implement lifecycle policies
- Enable auto-scaling
- Documentation
- Update README.md for new features
- Add inline comments for complex logic
- Include examples

## 🧪 Testing
Before submitting a PR, ensure:

Validation ```terraform validate```
Formatting```terraform fmt -check -recursive```
Plan Review ```terraform plan```
Security Scan
```
   # Install tfsec
   brew install tfsec
   
   # Run scan
   tfsec .
```
Linting
```
   # Install tflint
   brew install tflint
   
   # Run linter
   tflint
```
## 🔄 Pull Request Process
- Update Documentation
- Update README.md if needed
- Add comments to new code
- Update CHANGELOG.md (if exists)
- Create Pull Request
- Use a clear, descriptive title
- Reference related issues
- Describe changes in detail
- Include screenshots if relevant


## PR Description Template

```
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update
   
   ## Testing
   - [ ] Terraform validate passed
   - [ ] Terraform plan reviewed
   - [ ] Security scan passed
   - [ ] Tested in dev environment
   
   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Comments added for complex logic
   - [ ] Documentation updated
   - [ ] No secrets in code
```

### Code Review
- Address reviewer feedback
- Update PR as needed
-  Keep discussion professional and constructive

### 📋 Commit Message Guidelines
Use clear, descriptive commit messages:


- feat: add CloudFront distribution for static assets
- fix: correct security group ingress rules
- docs: update README with new variables
- refactor: restructure compute module
- chore: update Terraform to v1.5

### Prefixes:

- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- refactor: Code refactoring
- test: Test updates
- chore: Maintenance tasks
## 🐛 Reporting Bugs
Before submitting:

- Check existing issues
- Verify it's reproducible
- Test with latest version

Bug Report Template:
```
## Description
Clear description of the bug

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- Terraform version: 
- AWS region: 
- OS: 
```

## Additional Context
Any other relevant information
💡 Suggesting Features
Feature Request Template:



#### Feature Description
Clear description of the feature

### Problem Statement
What problem does this solve?

### Proposed Solution
How should it work?

### Alternatives Considered
Other approaches considered

### Additional Context
Any other relevant information

#### 📚 Resources
- Terraform Documentation
- AWS Documentation
- Terraform Best Practices
- AWS Well-Architected Framework

🙏 Thank You!


Your contributions make this project better for everyone. We appreciate your time and effort!

###📜 License
By contributing, you agree that your contributions will be licensed under the project's MIT License.

