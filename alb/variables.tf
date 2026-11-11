variable "vpc" {
  description = "VPC ID for the target groups."
  type        = string
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener."
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate."
  type        = string
}

variable "name" {
  description = "Name of the load balancer."
  type        = string
}

variable "enable_logs" {
  description = "Enable logs for Load Balancer."
  type        = bool
  default     = false
}

variable "bucket_name" {
  description = "Name of the load balancer's access log bucket."
  type        = string
  default     = null
}

variable "target_groups" {
  description = "List of target group configurations."
  type = list(object({
    name                 = string
    port                 = number
    protocol             = optional(string, "HTTP")
    health_check_path    = optional(string, "/")
    health_check_port    = optional(number, null)
    health_check_matcher = optional(string, "200")
    health_check_interval = optional(number, 30)
    health_check_timeout  = optional(number, 5)
    healthy_threshold     = optional(number, 5)
    unhealthy_threshold   = optional(number, 2)
  }))
}

variable "default_target_group" {
  description = "Name of the default target group for the listeners. Must match a name in target_groups."
  type        = string
}
variable "internal" {
  description = "Whether the LB is internal."
  type        = bool
}

variable "security_groups" {
  description = "List of security group IDs for the LB."
  type        = list(string)
}

variable "subnets" {
  description = "List of subnet IDs for the LB."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = null
}

# Access Logs Configuration
variable "access_logs_prefix" {
  description = "S3 bucket prefix for ALB access logs. Defaults to the ALB name if not specified."
  type        = string
  default     = null
}

variable "access_logs_retention_days" {
  description = "Number of days to retain ALB access logs in S3."
  type        = number
  default     = 90
}
