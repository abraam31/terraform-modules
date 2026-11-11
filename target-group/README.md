# Target Group Terraform Module

This module creates one or more AWS load balancer target groups.

## Usage

```hcl
module "target_group" {
  source = "git@github.com:localytics/devops-terraform-modules.git//target-group?ref=master"

  vpc_id = "vpc-123456"

  target_groups = [
    {
      name        = "my-service"
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"

      health_check = {
        path    = "/health"
        matcher = "200"
      }
    }
  ]

  tags = {
    Environment = "prod"
  }
}
```

## Variables

See `variables.tf` for all configurable options.

## Outputs

See `output.tf` for output values.
