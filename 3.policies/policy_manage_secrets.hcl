# Manage secrets engines (sys/mount is where vault uses to mount any secrets. It's root protected, so it needs sudo capabilities)
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List existing secrets engines.
path "sys/mounts"
{
  capabilities = ["read"]
}
