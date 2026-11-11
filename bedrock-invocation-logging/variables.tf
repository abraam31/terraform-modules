variable "name_prefix" {
  description = "Prefix used for the IAM role, IAM policy, and KMS alias names."
  type        = string
  default     = "bedrock-invocation-logging"
}

variable "bucket_name" {
  description = "Name of the S3 bucket that receives invocation logs. Must be globally unique."
  type        = string
}

variable "s3_key_prefix" {
  description = "Key prefix for invocation logs delivered to S3."
  type        = string
  default     = "invocation-logs"

  validation {
    condition     = length(var.s3_key_prefix) > 0 && !startswith(var.s3_key_prefix, "/") && !endswith(var.s3_key_prefix, "/")
    error_message = "s3_key_prefix must be non-empty and must not start or end with a slash."
  }
}

variable "large_data_key_prefix" {
  description = "Key prefix for payloads larger than 100 KB that CloudWatch Logs cannot hold."
  type        = string
  default     = "large-data"

  validation {
    condition     = length(var.large_data_key_prefix) > 0 && !startswith(var.large_data_key_prefix, "/") && !endswith(var.large_data_key_prefix, "/")
    error_message = "large_data_key_prefix must be non-empty and must not start or end with a slash."
  }
}

variable "log_group_name" {
  description = "Name of the CloudWatch Logs log group that receives invocation logs."
  type        = string
  default     = "/aws/bedrock/model-invocations"
}

variable "log_retention_in_days" {
  description = "Retention period for the CloudWatch Logs log group."
  type        = number
  default     = 90
}

variable "s3_transition_to_ia_days" {
  description = "Days after which S3 log objects move to STANDARD_IA."
  type        = number
  default     = 30
}

variable "s3_transition_to_glacier_ir_days" {
  description = "Days after which S3 log objects move to GLACIER_IR."
  type        = number
  default     = 90
}

variable "s3_expiration_days" {
  description = "Days after which S3 log objects are deleted."
  type        = number
  default     = 365

  validation {
    condition     = var.s3_expiration_days > var.s3_transition_to_glacier_ir_days && var.s3_transition_to_glacier_ir_days > var.s3_transition_to_ia_days && var.s3_transition_to_ia_days >= 30
    error_message = "Lifecycle days must satisfy 30 <= s3_transition_to_ia_days < s3_transition_to_glacier_ir_days < s3_expiration_days."
  }
}

variable "s3_noncurrent_version_expiration_days" {
  description = "Days after which noncurrent S3 object versions are deleted."
  type        = number
  default     = 30
}

variable "kms_deletion_window_in_days" {
  description = "Waiting period before the KMS key is deleted after being scheduled for deletion."
  type        = number
  default     = 30
}

variable "text_data_delivery_enabled" {
  description = "Log text prompts and responses."
  type        = bool
  default     = true
}

variable "image_data_delivery_enabled" {
  description = "Log image inputs and outputs."
  type        = bool
  default     = true
}

variable "embedding_data_delivery_enabled" {
  description = "Log embedding inputs and outputs."
  type        = bool
  default     = true
}

variable "video_data_delivery_enabled" {
  description = "Log video inputs and outputs."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = null
}
