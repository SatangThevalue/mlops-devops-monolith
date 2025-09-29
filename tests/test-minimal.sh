#!/bin/bash
set -e

echo "🧪 Testing Minimal Stack Deployment"

# Function to test HTTP endpoint
test_endpoint() {
    local url=$1
    local expected_status=${2:-200}
    local name=$3
    
    echo -n "Testing $name ($url)... "
    
    # Use curl with timeout and retry
    if status=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 30 --retry 3 "$url"); then
        if [ "$status" -eq "$expected_status" ]; then
            echo "✅ OK (HTTP $status)"
        else
            echo "❌ FAIL (HTTP $status, expected $expected_status)"
            return 1
        fi
    else
        echo "❌ FAIL (connection error)"
        return 1
    fi
}

# Function to test service via Docker
test_docker_service() {
    local service=$1
    local port=$2
    local path=${3:-"/"}
    
    echo -n "Testing $service container... "
    
    if docker-compose ps | grep -q "$service.*Up"; then
        echo "✅ Running"
        if [ "$port" ]; then
            test_endpoint "http://localhost:$port$path" 200 "$service HTTP"
        fi
    else
        echo "❌ Not running"
        return 1
    fi
}

echo "🐳 Checking Docker Compose services..."

# Test core infrastructure
test_docker_service "postgres" "5432"
test_docker_service "redis" "6379" 
test_docker_service "traefik" "8080" "/ping"

# Test main services
test_docker_service "vault" "8200" "/v1/sys/health"
test_docker_service "authelia" "" 

# Test application services
test_docker_service "prefect-server" "4200"
test_docker_service "mlflow" "5000"

echo ""
echo "📊 Service Status Summary:"
docker-compose ps

echo ""
echo "🔍 Testing service discovery and routing..."

# Test Traefik dashboard
test_endpoint "http://traefik.localhost:8080/dashboard/" 200 "Traefik Dashboard"

# Test if services are configured in Traefik
echo -n "Checking Traefik configuration... "
if curl -s "http://traefik.localhost:8080/api/http/routers" | grep -q "vault\|authelia\|prefect"; then
    echo "✅ Services configured in Traefik"
else
    echo "⚠️  Some services may not be configured in Traefik"
fi

echo ""
echo "🔐 Testing authentication endpoints..."

# Test Vault health
test_endpoint "http://localhost:8200/v1/sys/health" 200 "Vault Health"

# Test Authelia health
test_endpoint "http://localhost:9091/api/health" 200 "Authelia Health"

echo ""
echo "📈 Testing application endpoints..."

# Test Prefect
if curl -s "http://localhost:4200/api/health" | grep -q '"status":"ok"'; then
    echo "✅ Prefect API healthy"
else
    echo "⚠️  Prefect API may not be ready yet"
fi

# Test MLflow
if curl -s "http://localhost:5000" | grep -q "MLflow"; then
    echo "✅ MLflow UI accessible"
else
    echo "⚠️  MLflow UI may not be ready yet"
fi

echo ""
echo "📋 Resource Usage:"
echo "Memory usage by service:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}" | head -10

echo ""
echo "🎯 Testing complete! Check the logs if any services failed:"
echo "  docker-compose logs <service-name>"
echo ""
echo "🌐 Access URLs (add to /etc/hosts if not already done):"
echo "  127.0.0.1 traefik.localhost auth.localhost vault.localhost"
echo "  127.0.0.1 prefect.localhost mlflow.localhost plane.localhost"