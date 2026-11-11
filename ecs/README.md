# ECS Terraform Module

This module provisions AWS ECS resources, including cluster and service definitions.





## Usage
```hcl
module "ecs" {
  source = "git@github.com:localytics/devops-terraform-modules.git//ecs?ref=master"
}
```

> **Note:** You must have SSH access to `git@github.com:localytics/devops-terraform-modules.git` to use this source reference.

## Example
```hcl
module "ecs" {
  source                = "git@github.com:localytics/devops-terraform-modules.git//ecs?ref=master"
  cluster_name          = "my-ecs-cluster"
  container_definitions = file("container_definitions.json")
  # ...other variables as needed
}
```

## Variables
See `variables.tf` for all configurable options.

## Outputs
See `output.tf` for output values (if present).
