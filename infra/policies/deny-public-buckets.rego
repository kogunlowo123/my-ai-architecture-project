package terraform.deny_public_buckets

deny[msg] {
  r := input.resource_changes[_]
  r.type == "aws_s3_bucket_public_access_block"
  r.change.after.block_public_acls == false
  msg := sprintf("public bucket not allowed: %s", [r.address])
}
