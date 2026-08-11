# Model access + guardrail wiring for agent inference (Bedrock).
# PHI-touching inference uses a no-retention configuration and private endpoints.
resource "aws_bedrock_guardrail" "platform" {
  name                      = "${var.name}-guardrail"
  blocked_input_messaging   = "Request blocked by platform guardrail."
  blocked_outputs_messaging = "Response blocked by platform guardrail."

  sensitive_information_policy_config {
    dynamic "pii_entities_config" {
      for_each = var.pii_entities
      content {
        type   = pii_entities_config.value
        action = "ANONYMIZE"
      }
    }
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "model_invocations" {
  name              = "/aup/${var.env}/model-invocations"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.logs_kms_key_arn
}
