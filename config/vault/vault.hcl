storage "file" {
  path = "/vault/data"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"
ui = true

# Enable OIDC auth method
auth "oidc" {
  issuer = "https://auth.localhost"
  oidc_discovery_url = "https://auth.localhost/.well-known/openid_configuration"
  oidc_client_id = "vault"
  oidc_client_secret = "vault_secret"
  default_role = "default"
}

# Default configuration for development
disable_mlock = true