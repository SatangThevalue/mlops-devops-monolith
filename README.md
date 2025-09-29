# MLOps/DevOps Monolith Platform

A highly resource-efficient, self-hosted platform combining DevOps (Nomad, Vault), MLOps (Prefect, MLflow), and Project Management (Plane). Secured by Authelia SSO and configured for both Minimal (Local) and Full (VM) deployments.

## 🏗️ Architecture

### Core Components

- **🔐 Authelia**: Identity Provider (IdP) and Single Sign-On (SSO) with OIDC support
- **🛡️ HashiCorp Vault**: Secret management with template-based injection
- **🚦 Traefik**: Reverse proxy and load balancer with automatic HTTPS
- **📋 Nomad**: Container orchestration (Full Stack only)
- **🔧 Consul**: Service discovery and configuration (Full Stack only)
- **🌊 Prefect**: Workflow management and orchestration
- **📊 MLflow**: ML experiment tracking and model registry
- **📝 Plane**: Project management and issue tracking
- **🐘 PostgreSQL**: Database for various services
- **🔴 Redis**: Cache and message broker

### Deployment Options

#### Minimal Stack (Local 2C/8GB)
- **Orchestration**: Docker Compose only
- **Resource Requirements**: 2 CPU cores, 8GB RAM
- **Use Case**: Development, testing, small teams

#### Full Stack (VM 6C/16GB)
- **Orchestration**: HashiCorp Nomad
- **Secret Management**: Vault with template stanza injection
- **Resource Requirements**: 6 CPU cores, 16GB RAM
- **Use Case**: Production, larger teams, enterprise

## 🚀 Quick Start

### Prerequisites

#### Minimal Stack
- Docker & Docker Compose
- 2GB+ available RAM
- 10GB+ disk space

#### Full Stack
- HashiCorp Nomad, Consul, Vault
- Docker
- 6GB+ available RAM
- 20GB+ disk space

### Minimal Stack Deployment

1. **Clone and Start**:
   ```bash
   git clone https://github.com/SatangThevalue/mlops-devops-monolith.git
   cd mlops-devops-monolith
   ./start-minimal.sh
   ```

2. **Add Host Entries**:
   ```bash
   echo "127.0.0.1 traefik.localhost auth.localhost vault.localhost" >> /etc/hosts
   echo "127.0.0.1 prefect.localhost mlflow.localhost plane.localhost" >> /etc/hosts
   ```

3. **Access Services**:
   - Authelia SSO: https://auth.localhost
   - Traefik Dashboard: http://traefik.localhost:8080
   - Vault: https://vault.localhost
   - Prefect: https://prefect.localhost
   - MLflow: https://mlflow.localhost
   - Plane: https://plane.localhost

### Full Stack Deployment

1. **Install HashiCorp Tools**:
   ```bash
   # Install Nomad, Consul, Vault
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
   sudo apt-get update && sudo apt-get install nomad consul vault
   ```

2. **Start Full Stack**:
   ```bash
   ./start-full.sh
   ```

3. **Access Services**:
   - Nomad UI: http://127.0.0.1:4646
   - Consul UI: http://127.0.0.1:8500
   - Vault UI: http://127.0.0.1:8200
   - Same service URLs as Minimal Stack

## 🔐 Authentication & OIDC Setup

### Authelia Configuration

The platform uses Authelia as the central Identity Provider with OIDC clients pre-configured for all services:

#### Pre-configured OIDC Clients:
- **Prefect**: `prefect` client with workflow management access
- **MLflow**: `mlflow` client with ML experiment tracking access
- **Plane**: `plane` client with project management access
- **Vault**: `vault` client with secret management access

#### Default Users:
- **admin**: Administrator with full access (groups: admins, dev)
- **user**: Standard user with limited access (groups: dev)

#### Default Credentials:
- Username: `admin` or `user`
- Password: `password`

### Vault Secret Injection

The Full Stack deployment uses Vault's template stanza for secure secret injection:

#### Secret Paths:
- `secret/data/authelia-config`: Authelia configuration secrets
- `secret/data/authelia-users`: User credentials and hashes  
- `secret/data/prefect-config`: Prefect database and OIDC secrets
- `secret/data/vault-config`: Vault OIDC and configuration secrets

#### Template Usage Example:
```hcl
template {
  data = <<EOF
{{ with secret "secret/data/authelia-config" }}
jwt_secret: {{ .Data.data.jwt_secret }}
session_secret: {{ .Data.data.session_secret }}
{{ end }}
EOF
  destination = "local/config.yml"
  change_mode = "restart"
}
```

## 🛠️ Service Configuration

### Traefik Routing

All services are routed through Traefik with automatic HTTPS:

- **SSL**: Let's Encrypt automatic certificate generation
- **Authentication**: Authelia forward auth middleware
- **Load Balancing**: Automatic service discovery
- **Dashboard**: Available at http://traefik.localhost:8080

### Database Setup

PostgreSQL automatically creates separate databases:
- `prefect`: Prefect workflow metadata
- `mlflow`: ML experiment tracking data
- `plane`: Project management data
- `authelia`: User authentication data

### Network Configuration

- **Docker Network**: `mlops-network` bridge network
- **Service Discovery**: Automatic via container names
- **Port Mapping**: Standard ports with Traefik routing

## 📊 Monitoring & Observability

### Health Checks

All services include health checks:
- **HTTP Health Endpoints**: `/health`, `/api/health`, `/ping`
- **Check Intervals**: 10-second intervals with 3-second timeouts
- **Automatic Recovery**: Container restart on failure

### Logging

- **Centralized Logging**: All services log to stdout/stderr
- **Log Levels**: Configurable via environment variables
- **Access Logs**: Traefik provides detailed access logging

## 🔧 Customization

### Environment Variables

Create a `.env` file to customize settings:

```env
# Database
POSTGRES_USER=admin
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=mlops

# Authelia
AUTHELIA_JWT_SECRET=your_jwt_secret
AUTHELIA_SESSION_SECRET=your_session_secret

# Domain
DOMAIN=yourdomain.com
```

### Service Scaling

#### Minimal Stack:
- Edit `docker-compose.yml` to adjust resource limits
- Scale services: `docker-compose up -d --scale prefect-worker=3`

#### Full Stack:
- Modify Nomad job files in `nomad/` directory
- Adjust resource allocations and count values
- Redeploy: `nomad job run nomad/service.nomad`

## 🧪 Development & Testing

### Adding New Services

1. **Minimal Stack**: Add service to `docker-compose.yml`
2. **Full Stack**: Create new Nomad job file
3. **OIDC Integration**: Add client to Authelia configuration
4. **Routing**: Configure Traefik labels/routes

### Secret Management

#### Development:
- Use Docker Compose environment variables
- Store secrets in `.env` file (not committed)

#### Production:
- Use Vault for all secret storage
- Implement template stanza in Nomad jobs
- Rotate secrets regularly

## 📚 Additional Resources

### Official Documentation:
- [Authelia OIDC](https://www.authelia.com/integration/openid-connect/introduction/)
- [Vault Template Stanza](https://developer.hashicorp.com/nomad/docs/job-specification/template)
- [Nomad Job Specification](https://developer.hashicorp.com/nomad/docs/job-specification)
- [Traefik Configuration](https://doc.traefik.io/traefik/)
- [Prefect Deployment](https://docs.prefect.io/concepts/deployments/)
- [MLflow Tracking](https://mlflow.org/docs/latest/tracking.html)

### Support & Contributing

- **Issues**: Report issues on GitHub
- **Pull Requests**: Contributions welcome
- **Documentation**: Help improve this README

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.
