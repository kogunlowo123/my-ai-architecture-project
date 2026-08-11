# Contract: observability — interface only, zero providers. log sink, metrics workspace, retention days
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
