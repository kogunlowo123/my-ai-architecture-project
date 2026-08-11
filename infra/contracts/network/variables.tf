# Contract: network — interface only, zero providers. cidr plan, subnet tiers, egress mode
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
