#!/bin/bash
set -e

echo "🚀 Starting MLOps/DevOps Monolith Platform - Full Stack (Nomad)"

# Check if required tools are installed
for tool in nomad consul vault; do
    if ! command -v $tool &> /dev/null; then
        echo "❌ $tool is not installed. Please install HashiCorp tools first."
        exit 1
    fi
done

# Create data directories
sudo mkdir -p /opt/nomad/data /opt/consul/data /opt/vault/data
sudo chown -R $USER:$USER /opt/nomad /opt/consul /opt/vault

# Start Consul in dev mode
echo "🔧 Starting Consul..."
consul agent -dev -data-dir=/opt/consul/data -client=0.0.0.0 > consul.log 2>&1 &
CONSUL_PID=$!
echo $CONSUL_PID > consul.pid

# Wait for Consul
sleep 5

# Start Vault in dev mode
echo "🔐 Starting Vault..."
vault server -dev -dev-listen-address=0.0.0.0:8200 > vault.log 2>&1 &
VAULT_PID=$!
echo $VAULT_PID > vault.pid

# Export Vault environment
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='dev-only-token'

# Wait for Vault
sleep 5

# Initialize Vault with secrets
echo "📝 Setting up Vault secrets..."
vault auth enable oidc || true
vault kv put secret/authelia-config \
    jwt_secret="a_very_important_secret" \
    session_secret="another_very_important_secret" \
    storage_encryption_key="you_must_generate_a_random_string_of_more_than_twenty_chars_and_configure_this" \
    redis_host="127.0.0.1" \
    redis_port="6379" \
    postgres_host="127.0.0.1" \
    postgres_port="5432" \
    postgres_database="authelia" \
    postgres_username="admin" \
    postgres_password="secure_password" \
    smtp_username="test" \
    smtp_password="password" \
    smtp_host="mail.example.com" \
    smtp_port="587" \
    smtp_sender="admin@example.com" \
    oidc_hmac_secret="this_is_a_secret_abc123abc123abc" \
    prefect_client_secret="prefect_secret" \
    mlflow_client_secret="mlflow_secret" \
    plane_client_secret="plane_secret" \
    vault_client_secret="vault_secret"

# Start Nomad
echo "📋 Starting Nomad..."
sudo nomad agent -dev -data-dir=/opt/nomad/data -vault-enabled=true -vault-address=http://127.0.0.1:8200 -vault-token=dev-only-token > nomad.log 2>&1 &
NOMAD_PID=$!
echo $NOMAD_PID > nomad.pid

# Wait for Nomad
sleep 10

# Deploy jobs
echo "🚀 Deploying Nomad jobs..."
nomad job run nomad/traefik.nomad
nomad job run nomad/vault.nomad
nomad job run nomad/authelia.nomad  
nomad job run nomad/prefect.nomad

echo "✅ Full stack started successfully!"
echo ""
echo "🌐 Access URLs:"
echo "  - Nomad UI:          http://127.0.0.1:4646"
echo "  - Consul UI:         http://127.0.0.1:8500"
echo "  - Vault UI:          http://127.0.0.1:8200"
echo "  - Traefik Dashboard: http://traefik.localhost:8080"
echo "  - Authelia (SSO):    https://auth.localhost"
echo "  - Prefect:           https://prefect.localhost"
echo ""
echo "🔐 Vault Token: dev-only-token"
echo ""
echo "📋 Job Status:"
nomad job status