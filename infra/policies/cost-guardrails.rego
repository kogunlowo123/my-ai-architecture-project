package terraform.cost

# deny GPU pools in dev; instance size ceilings per env
deny[msg] {
  input.env == "dev"
  r := input.resource_changes[_]
  contains(r.address, "gpu")
  msg := "GPU pools denied in dev"
}
