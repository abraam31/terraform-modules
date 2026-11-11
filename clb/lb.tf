resource "aws_elb" "classic_lb" {
  for_each = { for lb in var.clb : lb.name => lb }

  name     = each.value.name
  internal = each.value.internal

  listener {
    instance_port     = each.value.instance_port
    instance_protocol = "http"
    lb_port           = each.value.listener_port
    lb_protocol       = "http"
  }

  dynamic "listener" {
    for_each = each.value.enable_https ? [1] : []

    content {
      instance_port      = each.value.instance_port
      instance_protocol  = "http"
      lb_port            = 443
      lb_protocol        = "https"
      ssl_certificate_id = each.value.ssl_certificate_id
    }
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 2
    target              = each.value.health_check_path
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 300

  subnets         = each.value.subnets
  security_groups = each.value.security_groups

  tags = var.tags != null ? var.tags : {}
}
