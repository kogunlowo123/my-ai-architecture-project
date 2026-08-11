"""Caller principal intersected with chunk ACL BEFORE scoring — never post-hoc."""

def acl_filter(chunks, principal_groups: set[str]):
    return [c for c in chunks if not c.acl or principal_groups.intersection(c.acl)]
