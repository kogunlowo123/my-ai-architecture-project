resource "aws_s3_bucket" "tf_state" {
  bucket = "aup-terraform-state-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "aup-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_kms_key" "audit_chain" {
  description              = "Signs audit-chain checkpoints (asymmetric)"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"
}

resource "aws_kms_alias" "audit_chain" {
  name          = "alias/audit-chain-signing"
  target_key_id = aws_kms_key.audit_chain.key_id
}

data "aws_caller_identity" "current" {}
