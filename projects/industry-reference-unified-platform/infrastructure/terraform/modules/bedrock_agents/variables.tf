variable "name" { type = string }
variable "env" { type = string }
variable "pii_entities" {
  type    = list(string)
  default = ["NAME", "EMAIL", "PHONE", "US_SOCIAL_SECURITY_NUMBER", "ADDRESS"]
}
variable "log_retention_days" {
  type    = number
  default = 400
}
variable "logs_kms_key_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
