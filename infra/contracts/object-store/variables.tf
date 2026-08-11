# Contract: object-store — interface only, zero providers. versioning, lifecycle, KMS key in
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
