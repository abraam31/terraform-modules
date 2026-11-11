data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.region
  partition  = data.aws_partition.current.partition

  bedrock_source_arn = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:*"
  log_group_arn      = "arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${var.log_group_name}"

  tags = var.tags != null ? var.tags : {}
}

resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  logging_config {
    text_data_delivery_enabled      = var.text_data_delivery_enabled
    image_data_delivery_enabled     = var.image_data_delivery_enabled
    embedding_data_delivery_enabled = var.embedding_data_delivery_enabled
    video_data_delivery_enabled     = var.video_data_delivery_enabled

    cloudwatch_config {
      log_group_name = aws_cloudwatch_log_group.invocations.name
      role_arn       = aws_iam_role.bedrock_logging.arn

      large_data_delivery_s3_config {
        bucket_name = aws_s3_bucket.invocations.id
        key_prefix  = var.large_data_key_prefix
      }
    }

    s3_config {
      bucket_name = aws_s3_bucket.invocations.id
      key_prefix  = var.s3_key_prefix
    }
  }

  depends_on = [
    aws_s3_bucket_policy.invocations,
    aws_s3_bucket_server_side_encryption_configuration.invocations,
    aws_iam_role_policy.bedrock_logging,
  ]
}
