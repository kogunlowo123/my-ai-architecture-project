# Contract: kubernetes — interface only, zero providers. node pools, OIDC issuer URL out
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
