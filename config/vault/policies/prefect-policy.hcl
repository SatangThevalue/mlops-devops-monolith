# Prefect policy - allows read access to prefect configuration secrets
path "secret/data/prefect-*" {
  capabilities = ["read"]
}

path "secret/metadata/prefect-*" {
  capabilities = ["list", "read"]
}

# Allow token lookup for health checks
path "auth/token/lookup-self" {
  capabilities = ["read"]
}