job "authelia" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "authelia" {
    count = 1

    network {
      port "authelia" {
        to = 9091
      }
    }

    service {
      name = "authelia"
      port = "authelia"
      
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.authelia.rule=Host(`auth.localhost`)",
        "traefik.http.services.authelia.loadbalancer.server.port=9091"
      ]
      
      check {
        type     = "http"
        path     = "/api/health"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "authelia" {
      driver = "docker"

      config {
        image = "authelia/authelia:4.38"
        ports = ["authelia"]
      }

      # Template for Authelia configuration with secret injection from Vault
      template {
        data = <<EOF
{{ with secret "secret/data/authelia-config" }}
---
theme: dark
jwt_secret: {{ .Data.data.jwt_secret }}
default_redirection_url: https://auth.localhost

server:
  host: 0.0.0.0
  port: 9091

log:
  level: info

totp:
  issuer: authelia.com

authentication_backend:
  password_reset:
    disable: false
  file:
    path: /config/users_database.yml
    password:
      algorithm: argon2id
      iterations: 1
      salt_length: 16
      parallelism: 8
      memory: 64

access_control:
  default_policy: deny
  rules:
    - domain: auth.localhost
      policy: bypass
    - domain: traefik.localhost
      policy: bypass
    - domain: "*.localhost"
      policy: one_factor

session:
  name: authelia_session
  secret: {{ .Data.data.session_secret }}
  expiration: 3600
  inactivity: 300
  domain: localhost
  redis:
    host: {{ .Data.data.redis_host }}
    port: {{ .Data.data.redis_port }}

regulation:
  max_retries: 3
  find_time: 120
  ban_time: 300

storage:
  encryption_key: {{ .Data.data.storage_encryption_key }}
  postgres:
    host: {{ .Data.data.postgres_host }}
    port: {{ .Data.data.postgres_port }}
    database: {{ .Data.data.postgres_database }}
    username: {{ .Data.data.postgres_username }}
    password: {{ .Data.data.postgres_password }}

notifier:
  smtp:
    username: {{ .Data.data.smtp_username }}
    password: {{ .Data.data.smtp_password }}
    host: {{ .Data.data.smtp_host }}
    port: {{ .Data.data.smtp_port }}
    sender: {{ .Data.data.smtp_sender }}
    disable_require_tls: true

# OIDC Configuration with secrets from Vault
identity_providers:
  oidc:
    hmac_secret: {{ .Data.data.oidc_hmac_secret }}
    issuer_private_key: |
{{ .Data.data.oidc_private_key | indent 6 }}
    clients:
      - id: prefect
        description: Prefect Workflow Management
        secret: '{{ .Data.data.prefect_client_secret }}'
        public: false
        authorization_policy: one_factor
        redirect_uris:
          - https://prefect.localhost/oauth/callback
        scopes:
          - openid
          - profile
          - email
        response_types:
          - code
        grant_types:
          - authorization_code
      
      - id: mlflow
        description: MLflow ML Tracking
        secret: '{{ .Data.data.mlflow_client_secret }}'
        public: false
        authorization_policy: one_factor
        redirect_uris:
          - https://mlflow.localhost/oauth/callback
        scopes:
          - openid
          - profile
          - email
        response_types:
          - code
        grant_types:
          - authorization_code
      
      - id: plane
        description: Plane Project Management
        secret: '{{ .Data.data.plane_client_secret }}'
        public: false
        authorization_policy: one_factor
        redirect_uris:
          - https://plane.localhost/oauth/callback
        scopes:
          - openid
          - profile
          - email
        response_types:
          - code
        grant_types:
          - authorization_code
      
      - id: vault
        description: HashiCorp Vault
        secret: '{{ .Data.data.vault_client_secret }}'
        public: false
        authorization_policy: one_factor
        redirect_uris:
          - https://vault.localhost/ui/vault/auth/oidc/oidc/callback
          - https://vault.localhost/oidc/callback
        scopes:
          - openid
          - profile
          - email
          - groups
        response_types:
          - code
        grant_types:
          - authorization_code
{{ end }}
EOF
        destination = "local/configuration.yml"
        change_mode = "restart"
      }

      # Users database template with secrets
      template {
        data = <<EOF
{{ with secret "secret/data/authelia-users" }}
---
users:
  admin:
    displayname: "Administrator"
    password: "{{ .Data.data.admin_password_hash }}"
    email: admin@localhost
    groups:
      - admins
      - dev

  user:
    displayname: "User"  
    password: "{{ .Data.data.user_password_hash }}"
    email: user@localhost
    groups:
      - dev
{{ end }}
EOF
        destination = "local/users_database.yml"
        change_mode = "restart"
      }

      resources {
        cpu    = 300
        memory = 256
      }

      vault {
        policies = ["authelia-policy"]
      }
    }
  }
}