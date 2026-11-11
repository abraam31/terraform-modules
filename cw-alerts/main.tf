resource "aws_cloudwatch_metric_alarm" "alarms" {
  for_each = { for alarm in var.alarms : alarm.alarm_name => alarm }

  alarm_name                            = each.value.alarm_name
  alarm_description                     = each.value.alarm_description
  tags = var.tags != null ? var.tags : {}

  namespace                             = each.value.namespace
  metric_name                           = each.value.metric_name

  comparison_operator                   = each.value.comparison_operator
  evaluation_periods                    = each.value.evaluation_periods
  datapoints_to_alarm                   = each.value.datapoints_to_alarm
  threshold                             = each.value.threshold
  threshold_metric_id                   = each.value.threshold_metric_id
  period                                = each.value.period
  statistic                             = each.value.statistic
  extended_statistic                    = each.value.extended_statistic
  unit                                  = each.value.unit
  dimensions                            = each.value.dimensions
  treat_missing_data                    = each.value.treat_missing_data
  evaluate_low_sample_count_percentiles = each.value.evaluate_low_sample_count_percentiles
  actions_enabled                       = each.value.actions_enabled
  alarm_actions                         = each.value.alarm_actions
  ok_actions                            = each.value.ok_actions
  insufficient_data_actions             = each.value.insufficient_data_actions

}
