# Contract: kms — interface only, zero providers. key rotation days, admin vs use principals
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
