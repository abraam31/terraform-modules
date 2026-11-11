variable "vpc_id" {
  description = "VPC ID where the target groups are created."
  type        = string
}

variable "target_groups" {
  description = "List of load balancer target groups to create."
  type = list(object({
    name                 = string
    port                 = number
    protocol             = optional(string, "HTTP")
    protocol_version     = optional(string, null)
    target_type          = optional(string, "instance")
    deregistration_delay = optional(number, 300)
    slow_start           = optional(number, null)

    health_check = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string, "/")
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "HTTP")
      interval            = optional(number, 30)
      timeout             = optional(number, 5)
      healthy_threshold   = optional(number, 2)
      unhealthy_threshold = optional(number, 3)
      matcher             = optional(string, "200")
    }), null)

    stickiness = optional(object({
      type            = optional(string, "lb_cookie")
      cookie_duration = optional(number, 86400)
      cookie_name     = optional(string, null)
      enabled         = optional(bool, false)
    }), null)
  }))

  validation {
    condition     = length(var.target_groups) == length(toset([for target_group in var.target_groups : target_group.name]))
    error_message = "Each target group must have a unique name."
  }
}

variable "tags" {
  description = "Tags to apply to target groups."
  type        = map(string)
  default     = null
}
