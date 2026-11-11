variable "replication_groups" {
  description = "List of ElastiCache replication groups to create."
  type = list(object({
    name                       = string
    description                = string
    engine                     = string
    engine_version             = string
    node_type                  = string
    parameter_group_name       = string
    subnet_group_name          = string
    security_group_ids         = list(string)
    port                       = optional(number, 6379)
    cluster_mode               = optional(string, "disabled")
    num_node_groups            = optional(number, null)
    replicas_per_node_group    = optional(number, 1)
    at_rest_encryption_enabled = optional(bool, false)
    transit_encryption_enabled = optional(bool, true)
    transit_encryption_mode    = optional(string, "preferred")
    automatic_failover_enabled = optional(bool, false)
    multi_az_enabled           = optional(bool, false)
    auth_token_update_strategy = optional(string, null)
    tags                       = optional(map(string), {})
  }))

  validation {
    condition     = length(var.replication_groups) == length(toset([for cluster in var.replication_groups : cluster.name]))
    error_message = "Each replication group must have a unique name."
  }

  validation {
    condition = alltrue([
      for cluster in var.replication_groups : contains(["disabled", "enabled"], cluster.cluster_mode)
    ])
    error_message = "cluster_mode must be either disabled or enabled."
  }

  validation {
    condition = alltrue([
      for cluster in var.replication_groups :
      cluster.cluster_mode == "disabled" || cluster.num_node_groups != null
    ])
    error_message = "num_node_groups is required when cluster_mode is enabled."
  }
}

variable "tags" {
  description = "Tags to apply to replication groups."
  type        = map(string)
  default     = null
}
