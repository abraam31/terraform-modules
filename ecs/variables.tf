variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "deploy" {
  description = "deploy environment [sandbox, prod]"
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "desired_count" {
    description = "The number of instances of the task definition to place and keep running"
    type        = number
    default     = 1
}

variable "region" {
  default = "us-east-1"
}


variable "account_id" {
}

variable "image_tag" {
  type        = string
}

variable "container_port" {
  type        = number
  default     = 80
}

variable "host_port" {
  type        = number
  default     = 0
}

variable "protocol" {
  type        = string
  default     = "tcp"
}

variable "cpu" {
  type        = number
  default     = 0
}

variable "memory" {
  type        = number
}

variable "tg_arn" {
  description = "The ARN of the target group to associate with the service"
  type        = string
}

variable "deployment_minimum_healthy_percent" {
  description = "The lower limit on the number of running tasks during a deployment"
  type        = number
  default     = 50
}

variable "deployment_maximum_percent" {
  description = "The upper limit on the number of running tasks during a deployment"
  type        = number
  default     = 200
}

variable "health_check_grace_period_seconds" {
  description = "The period of time, in seconds, that the Amazon ECS service scheduler ignores unhealthy Elastic Load Balancing target health checks after a task has first started"
  type        = number
  default     = 30
}

variable "access_logs_retention_days" {
  type        = number
  default     = 90
  description = "Retention time for the Services logs."
}