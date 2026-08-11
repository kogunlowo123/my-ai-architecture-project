# Audit WORM store + eval artifacts. Object Lock makes the audit chain tamper-evident
# at the storage layer too.
resource "aws_s3_bucket" "audit" {
  bucket              = "${var.name}-audit-${var.env}"
  object_lock_enabled = true
  tags                = var.tags
}

resource "aws_s3_bucket_object_lock_configuration" "audit" {
  bucket = aws_s3_bucket.audit.id
  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = var.audit_retention_days
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "audit" {
  bucket = aws_s3_bucket.audit.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "audit" {
  bucket                  = aws_s3_bucket.audit.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "evals" {
  bucket = "${var.name}-evals-${var.env}"
  tags   = var.tags
}
