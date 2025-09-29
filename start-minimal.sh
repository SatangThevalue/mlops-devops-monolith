#!/bin/bash
set -e

echo "🚀 Starting MLOps/DevOps Monolith Platform - Minimal Stack"

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create acme directory for Traefik certificates
mkdir -p config/traefik/acme
chmod 600 config/traefik/acme

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file with default values..."
    cat > .env << EOF
# Database Configuration
POSTGRES_DB=mlops
POSTGRES_USER=admin
POSTGRES_PASSWORD=secure_password

# Authelia Configuration
AUTHELIA_JWT_SECRET=a_very_important_secret
AUTHELIA_SESSION_SECRET=another_very_important_secret
AUTHELIA_STORAGE_ENCRYPTION_KEY=you_must_generate_a_random_string_of_more_than_twenty_chars_and_configure_this

# Plane Configuration
PLANE_SECRET_KEY=your-secret-key-here

# Domain Configuration
DOMAIN=localhost
EOF
fi

# Start the services
echo "🐳 Starting Docker Compose services..."
docker-compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to start..."
sleep 30

# Check service status
echo "🔍 Checking service status..."
docker-compose ps

echo "✅ Platform started successfully!"
echo ""
echo "🌐 Access URLs:"
echo "  - Traefik Dashboard: http://traefik.localhost:8080"
echo "  - Authelia (SSO):    https://auth.localhost"
echo "  - Vault:             https://vault.localhost"
echo "  - Prefect:           https://prefect.localhost"
echo "  - MLflow:            https://mlflow.localhost"
echo "  - Plane:             https://plane.localhost"
echo ""
echo "🔐 Default credentials:"
echo "  - Username: admin"
echo "  - Password: password"
echo ""
echo "📚 Next steps:"
echo "  1. Add the domains to your /etc/hosts file:"
echo "     127.0.0.1 traefik.localhost auth.localhost vault.localhost"
echo "     127.0.0.1 prefect.localhost mlflow.localhost plane.localhost"
echo "  2. Access Authelia at https://auth.localhost to set up 2FA"
echo "  3. Configure Vault OIDC auth at https://vault.localhost"
echo ""