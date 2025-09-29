#!/bin/bash
set -e

echo "🛑 Stopping MLOps/DevOps Monolith Platform"

# Stop and remove Docker Compose services
docker-compose down -v

echo "✅ Platform stopped successfully!"