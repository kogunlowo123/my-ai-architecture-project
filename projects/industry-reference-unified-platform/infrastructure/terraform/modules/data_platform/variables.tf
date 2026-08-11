variable "name" { type = string }
variable "env" { type = string }
variable "kms_key_arn" { type = string }
variable "audit_retention_days" {
  type    = number
  default = 2555 # ~7 years: HIPAA + tax audit-defense horizon
}
variable "tags" {
  type    = map(string)
  default = {}
}
