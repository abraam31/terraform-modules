resource "aws_s3_bucket" "invocations" {
  bucket        = var.bucket_name
  force_destroy = false
  tags          = local.tags
}

resource "aws_s3_bucket_public_access_block" "invocations" {
  bucket                  = aws_s3_bucket.invocations.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "invocations" {
  bucket = aws_s3_bucket.invocations.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "invocations" {
  bucket = aws_s3_bucket.invocations.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "invocations" {
  bucket = aws_s3_bucket.invocations.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.invocations.arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "invocations" {
  bucket = aws_s3_bucket.invocations.id

  rule {
    id     = "invocation-log-retention"
    status = "Enabled"

    filter {}

    transition {
      days          = var.s3_transition_to_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.s3_transition_to_glacier_ir_days
      storage_class = "GLACIER_IR"
    }

    expiration {
      days = var.s3_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.s3_noncurrent_version_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [aws_s3_bucket_versioning.invocations]
}

resource "aws_s3_bucket_policy" "invocations" {
  bucket = aws_s3_bucket.invocations.id
  policy = data.aws_iam_policy_document.bucket.json

  depends_on = [aws_s3_bucket_public_access_block.invocations]
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid     = "AmazonBedrockLogsWrite"
    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.invocations.arn}/${var.s3_key_prefix}/AWSLogs/${local.account_id}/BedrockModelInvocationLogs/*",
      "${aws_s3_bucket.invocations.arn}/${var.large_data_key_prefix}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.bedrock_source_arn]
    }
  }

  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.invocations.arn,
      "${aws_s3_bucket.invocations.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
