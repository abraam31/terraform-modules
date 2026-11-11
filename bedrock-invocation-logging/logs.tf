resource "aws_cloudwatch_log_group" "invocations" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_in_days
  kms_key_id        = aws_kms_key.invocations.arn
  tags              = local.tags
}
