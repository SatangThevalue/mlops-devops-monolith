# Authelia policy - allows read access to authelia configuration secrets
path "secret/data/authelia-*" {
  capabilities = ["read"]
}

path "secret/metadata/authelia-*" {
  capabilities = ["list", "read"]
}

# Allow token lookup for health checks
path "auth/token/lookup-self" {
  capabilities = ["read"]
}