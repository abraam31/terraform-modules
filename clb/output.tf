output "elb_names" {
  description = "Map of Classic Load Balancer names to load balancer names."
  value       = { for name, lb in aws_elb.classic_lb : name => lb.name }
}

output "elb_dns_names" {
  description = "Map of Classic Load Balancer names to DNS names."
  value       = { for name, lb in aws_elb.classic_lb : name => lb.dns_name }
}

output "elb_arns" {
  description = "Map of Classic Load Balancer names to ARNs."
  value       = { for name, lb in aws_elb.classic_lb : name => lb.arn }
}
