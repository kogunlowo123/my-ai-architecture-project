# Per-agent IRSA roles: one IAM role per agent identity, least-privilege,
# trust bound to the EKS OIDC issuer + the agent's exact k8s service account.
data "aws_iam_policy_document" "trust" {
  for_each = var.agents
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_issuer_hostpath}:sub"
      values   = ["system:serviceaccount:${var.namespace}:agent-${each.key}"]
    }
  }
}

resource "aws_iam_role" "agent" {
  for_each             = var.agents
  name                 = "agent-${each.key}-${var.env}"
  assume_role_policy   = data.aws_iam_policy_document.trust[each.key].json
  max_session_duration = 3600
  tags = merge(var.tags, {
    AgentTier   = tostring(each.value.tier)
    AgentDomain = each.value.domain
  })
}

resource "aws_iam_role_policy" "agent_scope" {
  for_each = var.agents
  name     = "scope"
  role     = aws_iam_role.agent[each.key].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = each.value.allowed_actions
      Resource = each.value.allowed_resources
    }]
  })
}
