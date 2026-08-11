variable "env" { type = string }
variable "namespace" {
  type    = string
  default = "agents"
}
variable "oidc_provider_arn" { type = string }
variable "oidc_issuer_hostpath" { type = string }
variable "agents" {
  description = "Map of agent name -> identity spec (mirrors platform/core/registry/manifest.yaml)"
  type = map(object({
    tier              = number
    domain            = string
    allowed_actions   = list(string)
    allowed_resources = list(string)
  }))
}
variable "tags" {
  type    = map(string)
  default = {}
}
