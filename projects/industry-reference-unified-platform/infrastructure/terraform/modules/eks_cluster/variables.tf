variable "name" { type = string }
variable "k8s_version" {
  type    = string
  default = "1.30"
}
variable "cluster_role_arn" { type = string }
variable "node_role_arn" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "secrets_kms_key_arn" { type = string }
variable "instance_types" {
  type    = list(string)
  default = ["m6i.xlarge"]
}
variable "desired_size" {
  type    = number
  default = 3
}
variable "min_size" {
  type    = number
  default = 2
}
variable "max_size" {
  type    = number
  default = 8
}
variable "tags" {
  type    = map(string)
  default = {}
}
