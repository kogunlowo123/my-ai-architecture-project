# Contract: messaging — interface only, zero providers. queue names, DLQ policy, visibility timeout
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
