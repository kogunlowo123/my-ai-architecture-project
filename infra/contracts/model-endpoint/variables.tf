# Contract: model-endpoint — interface only, zero providers. private endpoint URL out, quota profile
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
