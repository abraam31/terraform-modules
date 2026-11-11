resource "aws_cloudwatch_log_group" "ecs-service-logs-group" {
  name              = "${var.app_name}-${var.deploy}"
  retention_in_days = var.access_logs_retention_days
}

resource "aws_ecs_task_definition" "ecs-task" {
  depends_on = [ aws_cloudwatch_log_group.ecs-service-logs-group ]
  family                   = "${var.app_name}-${var.deploy}"
  region                   = var.region
  container_definitions    = templatefile("${path.module}/container_definitions.json.tftpl", { 
    app_name = var.app_name, 
    deploy = var.deploy, 
    account_id = var.account_id,
    image_tag = var.image_tag, 
    container_port = var.container_port, 
    host_port = var.host_port, 
    protocol = var.protocol, 
    cpu = var.cpu,
    memory = var.memory,
    region = var.region
  })

  placement_constraints {
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1d]"
    type       = "memberOf"
  }

  volume {
    configure_at_launch = false
    name                = "data"
  }
}

resource "aws_ecs_service" "ecs-service" {
  name            = "${var.app_name}-${var.deploy}"
  cluster         = var.cluster_arn
  task_definition = "${aws_ecs_task_definition.ecs-task.family}:${aws_ecs_task_definition.ecs-task.revision}"
  desired_count   = var.desired_count
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  deployment_maximum_percent = var.deployment_maximum_percent
}
