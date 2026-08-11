variable "name" { type = string }
variable "region" { type = string }
variable "vpc_cidr" { type = string }
variable "azs" { type = list(string) }
variable "flow_log_bucket_arn" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
