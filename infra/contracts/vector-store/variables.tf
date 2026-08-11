# Contract: vector-store — interface only, zero providers. dimensions, index type, replica count
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
