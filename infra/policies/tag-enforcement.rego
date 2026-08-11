package terraform.tags

required := {"owner", "domain", "tier", "cost-center"}

deny[msg] {
  r := input.resource_changes[_]
  missing := required - {k | r.change.after.tags[k]}
  count(missing) > 0
  msg := sprintf("%s missing tags: %v", [r.address, missing])
}
