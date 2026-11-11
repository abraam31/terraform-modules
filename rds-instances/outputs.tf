output "db_instance_ids" {
  description = "Map of DB instance names to instance identifiers."
  value       = { for name, instance in aws_db_instance.db_instances : name => instance.id }
}

output "endpoint_addresses" {
  description = "Map of DB instance names to endpoint addresses."
  value       = { for name, instance in aws_db_instance.db_instances : name => instance.address }
}

output "db_instance_arns" {
  description = "Map of DB instance names to ARNs."
  value       = { for name, instance in aws_db_instance.db_instances : name => instance.arn }
}

output "master_user_secret_arns" {
  description = "Map of DB instance names to Secrets Manager ARNs for managed master passwords."
  value = {
    for name, instance in aws_db_instance.db_instances :
    name => try(instance.master_user_secret[0].secret_arn, null)
  }
}
