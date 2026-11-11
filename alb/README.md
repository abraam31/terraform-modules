# Application Load Balancer (ALB) Terraform Module

This module provisions an AWS Application Load Balancer (ALB).





## Usage
```hcl
module "alb" {
  source = "git@github.com:localytics/devops-terraform-modules.git//alb?ref=master"
}
```

> **Note:** You must have SSH access to `git@github.com:localytics/devops-terraform-modules.git` to use this source reference.

## Example
```hcl
module "alb" {
  source          = "git@github.com:localytics/devops-terraform-modules.git//alb?ref=master"
  name            = "my-alb"
  subnets         = ["subnet-123", "subnet-456"]
  security_groups = ["sg-123"]
  # ...other variables as needed
}
```

## Variables
See `variables.tf` for all configurable options.

## Outputs
See `output.tf` for output values.
