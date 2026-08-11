# Contract: gpu-pool — interface only, zero providers. accelerator type, taints, autoscale floor zero
variable "name" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
