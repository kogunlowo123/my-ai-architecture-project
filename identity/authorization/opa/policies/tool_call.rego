package identity.authz

default allow := false

allow {
  input.tool in data.grants[input.agent].tools
  input.tier_ok
}
