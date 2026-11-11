output "bucket_name" {
  description = "Name of the S3 bucket that receives invocation logs."
  value       = aws_s3_bucket.invocations.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket that receives invocation logs."
  value       = aws_s3_bucket.invocations.arn
}

output "log_group_name" {
  description = "Name of the CloudWatch Logs log group that receives invocation logs."
  value       = aws_cloudwatch_log_group.invocations.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Logs log group that receives invocation logs."
  value       = aws_cloudwatch_log_group.invocations.arn
}

output "role_arn" {
  description = "ARN of the IAM role Bedrock assumes to write to CloudWatch Logs."
  value       = aws_iam_role.bedrock_logging.arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key encrypting the logs."
  value       = aws_kms_key.invocations.arn
}
