# Alarms wired to the governance model: hard-limit trips and audit gaps page humans.
resource "aws_cloudwatch_metric_alarm" "hard_limit_trips" {
  alarm_name          = "${var.name}-${var.env}-agent-hard-limit-trips"
  namespace           = "AUP/Orchestrator"
  metric_name         = "HardLimitTripped"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [var.pagerduty_sns_arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "audit_chain_gap" {
  alarm_name          = "${var.name}-${var.env}-audit-chain-verification-failed"
  namespace           = "AUP/Audit"
  metric_name         = "ChainVerificationFailed"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  alarm_actions       = [var.pagerduty_sns_arn]
  treat_missing_data  = "breaching" # silence here is itself an incident
}
