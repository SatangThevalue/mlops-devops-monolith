#!/bin/bash
set -e

echo "🛑 Stopping MLOps/DevOps Monolith Platform - Full Stack"

# Stop Nomad jobs
if command -v nomad &> /dev/null && nomad status &> /dev/null; then
    echo "📋 Stopping Nomad jobs..."
    nomad job stop traefik || true
    nomad job stop vault || true
    nomad job stop authelia || true
    nomad job stop prefect || true
    sleep 5
fi

# Stop Nomad
if [ -f nomad.pid ]; then
    NOMAD_PID=$(cat nomad.pid)
    echo "📋 Stopping Nomad (PID: $NOMAD_PID)..."
    sudo kill $NOMAD_PID || true
    rm -f nomad.pid
fi

# Stop Vault
if [ -f vault.pid ]; then
    VAULT_PID=$(cat vault.pid)
    echo "🔐 Stopping Vault (PID: $VAULT_PID)..."
    kill $VAULT_PID || true
    rm -f vault.pid
fi

# Stop Consul
if [ -f consul.pid ]; then
    CONSUL_PID=$(cat consul.pid)
    echo "🔧 Stopping Consul (PID: $CONSUL_PID)..."
    kill $CONSUL_PID || true
    rm -f consul.pid
fi

# Clean up log files
rm -f consul.log vault.log nomad.log

echo "✅ Full stack stopped successfully!"