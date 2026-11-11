output "lb_arn" {
  description = "ARN of the main load balancer."
  value       = aws_lb.main_lb.arn
}

output "lb_dns_name" {
  description = "DNS name of the main load balancer."
  value       = aws_lb.main_lb.dns_name
}

output "lb_security_groups" {
  description = "Security groups attached to the load balancer."
  value       = aws_lb.main_lb.security_groups
}

output "target_group_arns" {
  description = "Map of target group names to their ARNs."
  value       = { for name, tg in aws_lb_target_group.target_groups : name => tg.arn }
}

output "listener_http_arn" {
  description = "ARN of the HTTP listener."
  value       = aws_lb_listener.listener-http.arn
}

output "listener_https_arn" {
  description = "ARN of the HTTPS listener."
  value       = aws_lb_listener.listener-https.arn
}
