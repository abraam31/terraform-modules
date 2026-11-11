# RDS Instances Terraform Module

This module creates one or more AWS RDS DB instances using `for_each`.

## Usage

```hcl
module "rds_instances" {
  source = "git@github.com:localytics/devops-terraform-modules.git//rds-instances?ref=master"

  db_instances = [
    {
      name                 = "app-db"
      engine               = "postgres"
      engine_version       = "16.3"
      instance_class       = "db.t4g.medium"
      allocated_storage    = 100
      parameter_group_name = "default.postgres16"
      subnet_group_name    = "private-subnets"
      security_group_ids   = ["sg-123456"]
      db_name                       = "app"
      username                      = "app_user"
      manage_master_user_password   = true
      master_user_secret_kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/abc123"
      storage_encrypted             = true
      multi_az_enabled              = true
    },
    {
      name                 = "legacy-db"
      engine               = "postgres"
      engine_version       = "16.3"
      instance_class       = "db.t4g.small"
      allocated_storage    = 50
      parameter_group_name = "default.postgres16"
      subnet_group_name    = "private-subnets"
      security_group_ids   = ["sg-123456"]
      db_name              = "legacy"
      username             = "legacy_user"
      password             = var.db_password
    },
    {
      name                 = "analytics-db"
      engine               = "postgres"
      engine_version       = "16.3"
      instance_class       = "db.r6g.large"
      allocated_storage    = 500
      parameter_group_name = "default.postgres16"
      subnet_group_name    = "private-subnets"
      security_group_ids   = ["sg-123456"]
      storage_type         = "io1"
      iops                 = 3000
      storage_encrypted    = true
      deletion_protection  = true
    }
  ]

  tags = {
    Environment = "prod"
  }
}
```

## Password management

Each instance supports either:

- **Secrets Manager (recommended):** set `manage_master_user_password = true` and provide `username`. RDS creates and rotates the password in Secrets Manager. Use `master_user_secret_kms_key_id` to encrypt with a custom KMS key.
- **Inline password:** set `password` directly (do not set `manage_master_user_password`).

When using Secrets Manager, read the secret ARN from `module.rds_instances.master_user_secret_arns["app-db"]`.

## Import existing DB instances

Add each existing instance to `db_instances`, then import by map key (`name`):

```bash
terraform import 'module.rds_instances.aws_db_instance.db_instances["app-db"]' app-db
```

## Variables

See `variables.tf` for all configurable options.

## Outputs

See `outputs.tf` for output values.
