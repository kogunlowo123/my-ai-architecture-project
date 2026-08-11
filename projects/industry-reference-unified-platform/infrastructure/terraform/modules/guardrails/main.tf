# Preventive org guardrails: deny public S3, require encryption, restrict regions.
# Attach at the OU containing platform accounts.
resource "aws_organizations_policy" "platform_scp" {
  name    = "${var.name}-platform-scp"
  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyUnencryptedObjectUploads"
        Effect   = "Deny"
        Action   = "s3:PutObject"
        Resource = "*"
        Condition = { StringNotEquals = { "s3:x-amz-server-side-encryption" = "aws:kms" } }
      },
      {
        Sid       = "RestrictRegions"
        Effect    = "Deny"
        NotAction = ["iam:*", "organizations:*", "sts:*", "support:*"]
        Resource  = "*"
        Condition = { StringNotEquals = { "aws:RequestedRegion" = var.allowed_regions } }
      }
    ]
  })
}
