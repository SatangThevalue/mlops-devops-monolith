.PHONY: help start-minimal stop-minimal start-full stop-full status clean install

# Default target
help: ## Show this help message
	@echo "MLOps/DevOps Monolith Platform"
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Minimal Stack Commands
start-minimal: ## Start the minimal stack (Docker Compose)
	@echo "🚀 Starting Minimal Stack..."
	./start-minimal.sh

stop-minimal: ## Stop the minimal stack
	@echo "🛑 Stopping Minimal Stack..."
	./stop-minimal.sh

# Full Stack Commands  
start-full: ## Start the full stack (Nomad + Vault + Consul)
	@echo "🚀 Starting Full Stack..."
	./start-full.sh

stop-full: ## Stop the full stack
	@echo "🛑 Stopping Full Stack..."
	./stop-full.sh

# Status and Management
status: ## Check service status
	@echo "📊 Service Status:"
	@if command -v docker-compose >/dev/null 2>&1; then \
		echo "\nDocker Compose Services:"; \
		docker-compose ps; \
	fi
	@if command -v nomad >/dev/null 2>&1 && nomad status >/dev/null 2>&1; then \
		echo "\nNomad Jobs:"; \
		nomad job status; \
	fi

logs: ## Show service logs (minimal stack)
	@echo "📝 Service Logs:"
	docker-compose logs -f --tail=100

clean: ## Clean up stopped containers and volumes
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	docker system prune -f
	rm -f *.log *.pid

# Installation helpers
install-docker: ## Install Docker and Docker Compose (Ubuntu/Debian)
	@echo "📦 Installing Docker..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	sudo usermod -aG docker $$USER
	@echo "Docker installed. Please log out and log back in."

install-hashicorp: ## Install HashiCorp tools (Ubuntu/Debian)
	@echo "📦 Installing HashiCorp tools..."
	curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $$(lsb_release -cs) main"
	sudo apt-get update
	sudo apt-get install -y nomad consul vault

# Configuration
setup-hosts: ## Add localhost entries to /etc/hosts
	@echo "🌐 Setting up host entries..."
	@echo "127.0.0.1 traefik.localhost auth.localhost vault.localhost" | sudo tee -a /etc/hosts
	@echo "127.0.0.1 prefect.localhost mlflow.localhost plane.localhost" | sudo tee -a /etc/hosts
	@echo "Host entries added successfully!"

init-vault: ## Initialize Vault with sample secrets (development only)
	@echo "🔐 Initializing Vault with sample secrets..."
	@export VAULT_ADDR='http://127.0.0.1:8200' && \
	export VAULT_TOKEN='dev-only-token' && \
	vault kv put secret/authelia-config \
		jwt_secret="a_very_important_secret" \
		session_secret="another_very_important_secret" \
		storage_encryption_key="you_must_generate_a_random_string_of_more_than_twenty_chars_and_configure_this"

# Development
dev-minimal: setup-hosts start-minimal ## Setup hosts and start minimal stack for development

dev-full: install-hashicorp setup-hosts start-full init-vault ## Full development setup