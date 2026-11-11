variable "alarms" {
  description = "List of CloudWatch metric alarms to create."
  type = list(object({
    alarm_name                            = string
    alarm_description                     = optional(string, null)
    comparison_operator                   = string
    evaluation_periods                    = number
    datapoints_to_alarm                   = optional(number, null)
    threshold                             = number
    threshold_metric_id                   = optional(string, null)
    metric_name                           = string
    namespace                             = string
    period                                = number
    statistic                             = optional(string, null)
    extended_statistic                    = optional(string, null)
    unit                                  = optional(string, null)
    dimensions                            = optional(map(string), {})
    treat_missing_data                    = optional(string, "missing")
    evaluate_low_sample_count_percentiles = optional(string, null)
    actions_enabled                       = optional(bool, true)
    alarm_actions                         = optional(list(string), [])
    ok_actions                            = optional(list(string), [])
    insufficient_data_actions             = optional(list(string), [])
  }))

  validation {
    condition     = length(var.alarms) == length(toset([for alarm in var.alarms : alarm.alarm_name]))
    error_message = "Each CloudWatch alarm must have a unique alarm_name."
  }

  validation {
    condition     = alltrue([for alarm in var.alarms : (alarm.statistic != null) != (alarm.extended_statistic != null)])
    error_message = "Each CloudWatch alarm must set exactly one of statistic or extended_statistic."
  }
}

variable "tags" {
  description = "Tags to apply to CloudWatch alarms."
  type        = map(string)
  default     = null
}
