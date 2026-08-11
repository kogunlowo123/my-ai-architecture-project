output "agent_role_arns" { value = { for k, r in aws_iam_role.agent : k => r.arn } }
