# ElastiCache Replication Groups Terraform Module

This module creates one or more AWS ElastiCache replication groups using `for_each`.

## Usage

```hcl
module "elasticache_replication_groups" {
  source = "git@github.com:localytics/devops-terraform-modules.git//elasticache-replication-groups?ref=master"

  replication_groups = [
    {
      name                 = "app-cache"
      description          = "Application cache"
      engine               = "redis"
      engine_version       = "7.1"
      node_type            = "cache.t4g.small"
      parameter_group_name = "default.redis7"
      subnet_group_name    = "private-subnets"
      security_group_ids   = ["sg-123456"]
    },
    {
      name                 = "session-cache"
      description          = "Session cache"
      engine               = "redis"
      engine_version       = "7.1"
      node_type            = "cache.t4g.small"
      parameter_group_name = "default.redis7.cluster.on"
      subnet_group_name    = "private-subnets"
      security_group_ids   = ["sg-123456"]
      cluster_mode         = "enabled"
      num_node_groups      = 2
      replicas_per_node_group = 1
      automatic_failover_enabled = true
      multi_az_enabled         = true
    }
  ]

  tags = {
    Environment = "prod"
  }
}
```

## Import existing replication groups

Add each existing cluster to `replication_groups`, then import by map key (`name`):

```bash
terraform import 'module.elasticache_replication_groups.aws_elasticache_replication_group.replication_groups["app-cache"]' app-cache
```

## Variables

See `variables.tf` for all configurable options.

## Outputs

See `outputs.tf` for output values.
