# Vault policy - allows read access to vault configuration secrets
path "secret/data/vault-*" {
  capabilities = ["read"]
}

path "secret/metadata/vault-*" {
  capabilities = ["list", "read"]
}

# Allow auth operations
path "auth/oidc/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow token operations
path "auth/token/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow token lookup for health checks
path "auth/token/lookup-self" {
  capabilities = ["read"]
}