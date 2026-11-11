# Terraform Modules

This repository contains reusable Terraform modules for AWS infrastructure components. Each module is designed to be used independently and can be integrated into your Terraform projects to provision and manage AWS resources efficiently.

## Available Modules

- [`alb/`](alb/): Application Load Balancer (ALB)
- [`clb/`](clb/): Classic Load Balancer (CLB)
- [`target-group/`](target-group/): Load Balancer Target Groups
- [`elasticache-replication-groups/`](elasticache-replication-groups/): ElastiCache Replication Groups
- [`ecs/`](ecs/): ECS Cluster and Services
- [`rds-instances/`](rds-instances/): RDS Database Instances
- [`bedrock-invocation-logging/`](bedrock-invocation-logging/): Bedrock Model Invocation Logging to S3 and CloudWatch Logs

## Usage


1. **Choose a module**: Navigate to the desired module directory (e.g., `alb/`, `clb/`, `ecs/`, `rds/`).
2. **Reference the module** in your Terraform configuration with a few key variables:

   ```hcl
   module "clb" {
     source              = "git@github.com:localytics/devops-terraform-modules.git//clb?ref=master"
     name                = "my-clb"
     internal            = false
     subnets             = ["subnet-123", "subnet-456"]
     # ...other variables as needed
   }
   ```

   > **Note:** You must have SSH access to `git@github.com:localytics/devops-terraform-modules.git` to use this source reference.

3. **Configure additional variables**: Each module exposes variables for customization. See the module's own README for details.
4. **Apply your configuration**:
   ```sh
   terraform init
   terraform apply
   ```

## Requirements
- [Terraform](https://www.terraform.io/) >= 0.12
- AWS credentials configured (via environment variables, shared credentials file, or IAM roles)

## Module Structure
Each module contains:
- `variables.tf`: Input variables
- `output.tf`: Output values (if applicable)
- Resource definition files (e.g., `lb.tf`, `ecs.tf`, `rds.tf`)

## Contributing
Feel free to open issues or submit pull requests for improvements or new modules.

---
For module-specific usage, see the README in each module directory.
