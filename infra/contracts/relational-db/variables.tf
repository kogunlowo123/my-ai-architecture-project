# Contract: relational-db — interface only, zero providers. engine version, HA mode, backup window
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
