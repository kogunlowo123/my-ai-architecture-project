output "alarm_names" {
  value = [
    aws_cloudwatch_metric_alarm.hard_limit_trips.alarm_name,
    aws_cloudwatch_metric_alarm.audit_chain_gap.alarm_name,
  ]
}
