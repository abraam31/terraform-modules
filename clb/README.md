# Classic Load Balancer (CLB) Terraform Module

This module creates one or more AWS Classic Load Balancers using `for_each`.

## Usage

```hcl
module "clb" {
  source = "git@github.com:localytics/devops-terraform-modules.git//clb?ref=master"

  clb = [
    {
      name               = "public-clb"
      internal           = false
      enable_https       = true
      ssl_certificate_id = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"
      subnets            = ["subnet-123", "subnet-456"]
      security_groups    = ["sg-123"]
    },
    {
      name               = "internal-clb"
      internal           = true
      enable_https       = true
      ssl_certificate_id = "arn:aws:acm:us-east-1:123456789012:certificate/abc123"
      subnets            = ["subnet-789"]
      security_groups    = ["sg-456"]
    }
  ]

  tags = {
    Environment = "prod"
  }
}
```

## Import existing Classic Load Balancers

Add each existing load balancer to `clb`, then import by map key (`name`):

```bash
terraform import 'module.clb.aws_elb.classic_lb["public-clb"]' public-clb
```

## Variables

See `variables.tf` for all configurable options.

## Outputs

See `output.tf` for output values.
