resource "aws_elasticache_replication_group" "replication_groups" {
  for_each = { for cluster in var.replication_groups : cluster.name => cluster }

  replication_group_id       = each.value.name
  description                = each.value.description
  engine                     = each.value.engine
  engine_version             = each.value.engine_version
  node_type                  = each.value.node_type
  parameter_group_name       = each.value.parameter_group_name
  security_group_ids         = each.value.security_group_ids
  at_rest_encryption_enabled = each.value.at_rest_encryption_enabled
  transit_encryption_enabled = each.value.transit_encryption_enabled
  transit_encryption_mode    = each.value.transit_encryption_mode
  port                       = each.value.port
  subnet_group_name          = each.value.subnet_group_name
  automatic_failover_enabled = each.value.automatic_failover_enabled
  multi_az_enabled           = each.value.multi_az_enabled
  cluster_mode               = each.value.cluster_mode

  num_node_groups         = each.value.cluster_mode == "enabled" ? each.value.num_node_groups : null
  replicas_per_node_group = each.value.cluster_mode == "enabled" ? each.value.replicas_per_node_group : null

  auth_token_update_strategy = each.value.auth_token_update_strategy

  tags = merge(var.tags, try(each.value.tags, {}))
}
