variable "env" { type = string }
variable "region" {
  type    = string
  default = "us-east-1"
}
variable "vpc_cidr" { type = string }
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "node_desired_size" { type = number }
variable "flow_log_bucket_arn" { type = string }
variable "data_kms_key_arn" { type = string }
variable "eks_cluster_role_arn" { type = string }
variable "eks_node_role_arn" { type = string }
variable "eks_oidc_provider_arn" { type = string }
variable "pagerduty_sns_arn" { type = string }
variable "agents" {
  type = map(object({
    tier              = number
    domain            = string
    allowed_actions   = list(string)
    allowed_resources = list(string)
  }))
  default = {}
}
