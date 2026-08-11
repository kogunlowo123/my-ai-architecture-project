package terraform.require_kms

# every data store must reference a contract KMS key
deny[msg] {
  r := input.resource_changes[_]
  r.type == "aws_s3_bucket"
  not r.change.after.server_side_encryption_configuration
  msg := sprintf("missing KMS encryption: %s", [r.address])
}
