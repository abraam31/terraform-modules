variable "clb" {
  description = "List of Classic Load Balancers to create."
  type = list(object({
    name               = string
    instance_port      = optional(number, 9000)
    listener_port      = optional(number, 80)
    health_check_path  = optional(string, "HTTP:9000/ping")
    internal           = optional(bool, true)
    enable_https       = optional(bool, false)
    ssl_certificate_id = optional(string, null)
    subnets            = list(string)
    security_groups    = list(string)
  }))

  validation {
    condition     = length(var.clb) == length(toset([for lb in var.clb : lb.name]))
    error_message = "Each Classic Load Balancer must have a unique name."
  }

  validation {
    condition = alltrue([
      for lb in var.clb :
      !lb.enable_https || (lb.ssl_certificate_id != null && lb.ssl_certificate_id != "")
    ])
    error_message = "ssl_certificate_id is required when enable_https is true."
  }
}

variable "tags" {
  description = "Tags to apply to Classic Load Balancers."
  type        = map(string)
  default     = null
}
