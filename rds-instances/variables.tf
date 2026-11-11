variable "db_instances" {
  description = "List of RDS DB instances to create."
  type = list(object({
    name                          = string
    engine                        = string
    engine_version                = string
    instance_class                = string
    allocated_storage             = number
    parameter_group_name          = string
    subnet_group_name             = string
    security_group_ids            = list(string)
    port                          = optional(number, null)
    db_name                       = optional(string, null)
    username                      = optional(string, null)
    password                      = optional(string, null)
    manage_master_user_password   = optional(bool, false)
    master_user_secret_kms_key_id = optional(string, null)
    storage_encrypted             = optional(bool, false)
    multi_az_enabled              = optional(bool, false)
    publicly_accessible           = optional(bool, false)
    skip_final_snapshot           = optional(bool, true)
    deletion_protection           = optional(bool, false)
    backup_retention_period       = optional(number, 7)
    storage_type                  = optional(string, "gp3")
    max_allocated_storage         = optional(number, null)
    iops                          = optional(number, null)
    apply_immediately             = optional(bool, false)
    auto_minor_version_upgrade    = optional(bool, true)
    tags                          = optional(map(string), {})
  }))

  validation {
    condition     = length(var.db_instances) == length(toset([for instance in var.db_instances : instance.name]))
    error_message = "Each DB instance must have a unique name."
  }

  validation {
    condition = alltrue([
      for instance in var.db_instances : contains(["gp2", "gp3", "io1", "io2", "standard"], instance.storage_type)
    ])
    error_message = "storage_type must be one of gp2, gp3, io1, io2, or standard."
  }

  validation {
    condition = alltrue([
      for instance in var.db_instances :
      !contains(["io1", "io2"], instance.storage_type) || instance.iops != null
    ])
    error_message = "iops is required when storage_type is io1 or io2."
  }

  validation {
    condition = alltrue([
      for instance in var.db_instances :
      !instance.manage_master_user_password || instance.password == null
    ])
    error_message = "password must not be set when manage_master_user_password is true."
  }

  validation {
    condition = alltrue([
      for instance in var.db_instances :
      !instance.manage_master_user_password || instance.username != null
    ])
    error_message = "username is required when manage_master_user_password is true."
  }
}

variable "tags" {
  description = "Tags to apply to DB instances."
  type        = map(string)
  default     = null
}
