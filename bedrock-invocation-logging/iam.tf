resource "aws_iam_role" "bedrock_logging" {
  name               = "${var.name_prefix}-role"
  description        = "Assumed by Amazon Bedrock to deliver model invocation logs to CloudWatch Logs"
  assume_role_policy = data.aws_iam_policy_document.bedrock_assume_role.json
  tags               = local.tags
}

data "aws_iam_policy_document" "bedrock_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

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
}

resource "aws_iam_role_policy" "bedrock_logging" {
  name   = "${var.name_prefix}-cloudwatch-delivery"
  role   = aws_iam_role.bedrock_logging.id
  policy = data.aws_iam_policy_document.bedrock_logging.json
}

data "aws_iam_policy_document" "bedrock_logging" {
  statement {
    sid = "DeliverInvocationLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["${aws_cloudwatch_log_group.invocations.arn}:log-stream:aws/bedrock/modelinvocations"]
  }
}
