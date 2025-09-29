job "vault" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "vault" {
    count = 1

    network {
      port "vault" {
        to = 8200
      }
    }

    service {
      name = "vault"
      port = "vault"
      
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.vault.rule=Host(`vault.localhost`)",
        "traefik.http.services.vault.loadbalancer.server.port=8200"
      ]
      
      check {
        type     = "http"
        path     = "/v1/sys/health"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "vault" {
      driver = "docker"

      config {
        image = "vault:1.15"
        ports = ["vault"]
        
        cap_add = ["IPC_LOCK"]
      }

      # Template for Vault configuration with secret injection
      template {
        data = <<EOF
{{ with secret "secret/data/vault-config" }}
storage "consul" {
  address = "{{ env "NOMAD_IP_vault" }}:8500"
  path    = "vault/"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "true"
}

api_addr = "http://{{ env "NOMAD_IP_vault" }}:{{ env "NOMAD_PORT_vault" }}"
cluster_addr = "http://{{ env "NOMAD_IP_vault" }}:8201"
ui = true

# OIDC Configuration
auth "oidc" {
  issuer = "https://auth.localhost"
  oidc_discovery_url = "https://auth.localhost/.well-known/openid_configuration"
  oidc_client_id = "{{ .Data.data.oidc_client_id }}"
  oidc_client_secret = "{{ .Data.data.oidc_client_secret }}"
  default_role = "default"
}

disable_mlock = false
{{ end }}
EOF
        destination = "local/vault.hcl"
        change_mode = "restart"
      }

      # Environment template with secret injection
      template {
        data = <<EOF
{{ with secret "secret/data/vault-env" }}
VAULT_LOCAL_CONFIG=file:///local/vault.hcl
VAULT_API_ADDR=http://{{ env "NOMAD_IP_vault" }}:{{ env "NOMAD_PORT_vault" }}
VAULT_CLUSTER_ADDR=http://{{ env "NOMAD_IP_vault" }}:8201
{{ range $key, $value := .Data.data }}
{{ $key }}={{ $value }}
{{ end }}
{{ end }}
EOF
        destination = "secrets/vault.env"
        env         = true
      }

      resources {
        cpu    = 500
        memory = 512
      }

      vault {
        policies = ["vault-policy"]
      }
    }
  }
}