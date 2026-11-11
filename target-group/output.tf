output "target_group_arns" {
  description = "Map of target group names to ARNs."
  value       = { for name, target_group in aws_lb_target_group.target_groups : name => target_group.arn }
}

output "target_group_names" {
  description = "List of target group names."
  value       = keys(aws_lb_target_group.target_groups)
}

output "target_group_arn_suffixes" {
  description = "Map of target group names to ARN suffixes for CloudWatch dimensions."
  value       = { for name, target_group in aws_lb_target_group.target_groups : name => target_group.arn_suffix }
}
