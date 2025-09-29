job "prefect" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "prefect-server" {
    count = 1

    network {
      port "prefect" {
        to = 4200
      }
    }

    service {
      name = "prefect"
      port = "prefect"
      
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.prefect.rule=Host(`prefect.localhost`)",
        "traefik.http.services.prefect.loadbalancer.server.port=4200"
      ]
      
      check {
        type     = "http"
        path     = "/api/health"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "prefect-server" {
      driver = "docker"

      config {
        image = "prefecthq/prefect:2.14-python3.11"
        ports = ["prefect"]
        command = "prefect"
        args = ["server", "start", "--host", "0.0.0.0"]
      }

      # Environment template with secret injection from Vault
      template {
        data = <<EOF
{{ with secret "secret/data/prefect-config" }}
PREFECT_UI_URL=http://{{ env "NOMAD_IP_prefect" }}:{{ env "NOMAD_PORT_prefect" }}/api
PREFECT_API_URL=http://{{ env "NOMAD_IP_prefect" }}:{{ env "NOMAD_PORT_prefect" }}/api
PREFECT_SERVER_API_HOST=0.0.0.0
PREFECT_API_DATABASE_CONNECTION_URL=postgresql+asyncpg://{{ .Data.data.db_username }}:{{ .Data.data.db_password }}@{{ .Data.data.db_host }}:{{ .Data.data.db_port }}/{{ .Data.data.db_name }}

# OIDC Configuration for Prefect
PREFECT_OIDC_ISSUER=https://auth.localhost
PREFECT_OIDC_CLIENT_ID={{ .Data.data.oidc_client_id }}
PREFECT_OIDC_CLIENT_SECRET={{ .Data.data.oidc_client_secret }}
PREFECT_OIDC_REDIRECT_URI=https://prefect.localhost/oauth/callback
{{ end }}
EOF
        destination = "secrets/prefect.env"
        env         = true
      }

      resources {
        cpu    = 500
        memory = 1024
      }

      vault {
        policies = ["prefect-policy"]
      }
    }
  }

  group "prefect-worker" {
    count = 1

    task "prefect-worker" {
      driver = "docker"

      config {
        image = "prefecthq/prefect:2.14-python3.11"
        command = "prefect"
        args = ["worker", "start", "--pool", "default-pool"]
      }

      # Environment template with secret injection from Vault
      template {
        data = <<EOF
{{ with secret "secret/data/prefect-config" }}
PREFECT_API_URL=http://{{ env "NOMAD_IP_prefect" }}:4200/api
{{ range $key, $value := .Data.data }}
{{ $key }}={{ $value }}
{{ end }}
{{ end }}
EOF
        destination = "secrets/prefect-worker.env"
        env         = true
      }

      resources {
        cpu    = 300
        memory = 512
      }

      vault {
        policies = ["prefect-policy"]
      }
    }
  }
}