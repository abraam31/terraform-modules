# S3 bucket for ALB access logs
resource "aws_s3_bucket" "access_logs" {
  count  = var.enable_logs ? 1 : 0
  bucket = var.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  count  = var.enable_logs ? 1 : 0
  bucket = one(aws_s3_bucket.access_logs[*].id)

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    expiration {
      days = var.access_logs_retention_days
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  count  = var.enable_logs ? 1 : 0
  bucket = one(aws_s3_bucket.access_logs[*].id)

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "access_logs" {
  count  = var.enable_logs ? 1 : 0
  bucket = one(aws_s3_bucket.access_logs[*].id)

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${one(aws_s3_bucket.access_logs[*].arn)}/*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "logdelivery.elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = "${one(aws_s3_bucket.access_logs[*].arn)}"
      }
    ]
  })
}

resource "aws_lb" "main_lb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = true

  tags = var.tags != null ? var.tags : {}

  depends_on = [aws_s3_bucket_policy.access_logs]
  access_logs {
    #Using var.enable_logs for enabling logs.
    #Defaults to false, even when bucket is specified. Bucket creation depends of "count = var.enable_logs" .
    enabled = var.enable_logs
    bucket  = one(aws_s3_bucket.access_logs[*].id)
    prefix  = var.access_logs_prefix != null ? var.access_logs_prefix : var.name
  }
}

resource "aws_lb_target_group" "target_groups" {
  for_each = { for tg in var.target_groups : tg.name => tg }

  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc

  health_check {
    path                = each.value.health_check_path
    port                = each.value.health_check_port != null ? each.value.health_check_port : "traffic-port"
    interval            = each.value.health_check_interval
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    matcher             = each.value.health_check_matcher
  }

  tags = var.tags != null ? var.tags : {}
}

resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener-https" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy != null ? var.ssl_policy : "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_groups[var.default_target_group].arn
    forward {
      target_group {
        arn    = aws_lb_target_group.target_groups[var.default_target_group].arn
        weight = 1
      }
      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }
}
