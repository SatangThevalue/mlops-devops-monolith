job "traefik" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "traefik" {
    count = 1

    network {
      port "http" {
        static = 80
      }
      port "https" {
        static = 443
      }
      port "admin" {
        static = 8080
      }
    }

    service {
      name = "traefik"
      port = "admin"
      
      check {
        type     = "http"
        path     = "/ping"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:v3.0"
        ports = ["http", "https", "admin"]
        
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro",
          "local/traefik.yml:/etc/traefik/traefik.yml:ro"
        ]
      }

      template {
        data = <<EOF
global:
  checkNewVersion: false
  sendAnonymousUsage: false

api:
  dashboard: true
  insecure: true

entryPoints:
  web:
    address: ":80"
  websecure:
    address: ":443"

providers:
  consul:
    endpoints:
      - "{{ env "NOMAD_IP_admin" }}:8500"
  consulCatalog:
    prefix: traefik
    exposedByDefault: false
    endpoint:
      address: "{{ env "NOMAD_IP_admin" }}:8500"
      scheme: http
      datacenter: dc1

certificatesResolvers:
  letsencrypt:
    acme:
      email: admin@localhost
      storage: /acme/acme.json
      httpChallenge:
        entryPoint: web

log:
  level: INFO

accessLog: {}
EOF
        destination = "local/traefik.yml"
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}