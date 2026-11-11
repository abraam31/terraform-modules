output "alarm_arns" {
  description = "Map of CloudWatch alarm names to alarm ARNs."
  value       = { for name, alarm in aws_cloudwatch_metric_alarm.alarms : name => alarm.arn }
}

output "alarm_names" {
  description = "List of CloudWatch alarm names."
  value       = keys(aws_cloudwatch_metric_alarm.alarms)
}
