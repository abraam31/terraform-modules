output "replication_group_ids" {
  description = "Map of replication group names to replication group IDs."
  value       = { for name, cluster in aws_elasticache_replication_group.replication_groups : name => cluster.replication_group_id }
}

output "primary_endpoint_addresses" {
  description = "Map of replication group names to primary endpoint addresses."
  value       = { for name, cluster in aws_elasticache_replication_group.replication_groups : name => cluster.primary_endpoint_address }
}

output "configuration_endpoint_addresses" {
  description = "Map of replication group names to configuration endpoint addresses."
  value       = { for name, cluster in aws_elasticache_replication_group.replication_groups : name => cluster.configuration_endpoint_address }
}
