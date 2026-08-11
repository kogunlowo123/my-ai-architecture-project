variable "name" { type = string }
variable "allowed_regions" {
  type    = list(string)
  default = ["us-east-1", "us-east-2"]
}
