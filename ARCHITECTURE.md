# MLOps/DevOps Monolith Platform - Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          Internet / Users                              │
└─────────────────────────┬───────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       Traefik (Reverse Proxy)                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐  │
│  │   Port 80/443   │  │   Dashboard     │  │    Let's Encrypt SSL    │  │
│  │   HTTP/HTTPS    │  │   Port 8080     │  │    Certificate Mgmt     │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────┘  │
└─────────────────────────┬───────────────────────────────────────────────┘
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────────────────┐
│   Authelia      │ │     Vault       │ │      Application Services   │
│   (SSO/IdP)     │ │  (Secrets)      │ │                            │
│                 │ │                 │ │  ┌─────────────────────────┐ │
│  ┌───────────┐  │ │  ┌───────────┐  │ │  │       Prefect           │ │
│  │ OIDC      │  │ │  │ OIDC Auth │  │ │  │   (Workflow Mgmt)       │ │
│  │ Provider  │  │ │  │ KV Store  │  │ │  └─────────────────────────┘ │
│  │ User DB   │  │ │  │ Policies  │  │ │                            │
│  └───────────┘  │ │  └───────────┘  │ │  ┌─────────────────────────┐ │
│                 │ │                 │ │  │       MLflow            │ │
│  Port: 9091     │ │  Port: 8200     │ │  │   (ML Tracking)         │ │
└─────────────────┘ └─────────────────┘ │  └─────────────────────────┘ │
                                        │                            │
                                        │  ┌─────────────────────────┐ │
                                        │  │       Plane             │ │
                                        │  │  (Project Management)   │ │
                                        │  └─────────────────────────┘ │
                                        └─────────────────────────────┘
                                                      │
                                        ┌─────────────┼─────────────┐
                                        ▼             ▼             ▼
                                ┌─────────────┐ ┌─────────────┐ ┌─────────┐
                                │ PostgreSQL  │ │    Redis    │ │ Storage │
                                │ (Database)  │ │   (Cache)   │ │ Volumes │
                                │             │ │             │ │         │
                                │ Multi-DB:   │ │ Session     │ │ Artifacts│
                                │ - prefect   │ │ store       │ │ Logs    │
                                │ - mlflow    │ │ Message     │ │ Data    │
                                │ - plane     │ │ broker      │ │         │
                                │ - authelia  │ │             │ │         │
                                │             │ │ Port: 6379  │ │         │
                                │ Port: 5432  │ │             │ │         │
                                └─────────────┘ └─────────────┘ └─────────┘
```

## Deployment Architectures

### Minimal Stack (Docker Compose)
```
Host Machine (2C/8GB)
├── Docker Engine
├── Docker Compose Orchestration
├── Shared Bridge Network
├── Named Volumes for Persistence
└── Port Mapping for Services
```

### Full Stack (Nomad + Vault + Consul)
```
VM/Server (6C/16GB)
├── Nomad Agent (Orchestration)
├── Consul Agent (Service Discovery)
├── Vault Server (Secret Management)
├── Docker Driver (Container Runtime)
└── Template-based Secret Injection
```

## OIDC Authentication Flow

```
┌─────────────┐    1. Access Request    ┌─────────────┐
│    User     │ ────────────────────────→│   Traefik   │
└─────────────┘                         └─────────────┘
       ▲                                        │
       │                                        │ 2. Forward Auth
       │                                        ▼
       │                                ┌─────────────┐
       │                                │  Authelia   │
       │ 6. Access Service             │   (SSO)     │
       │                                └─────────────┘
       │                                        │
       │                                        │ 3. Redirect to Login
       │                                        ▼
┌─────────────┐    4. Login Form       ┌─────────────┐
│  Browser    │ ◄──────────────────────│  Auth Form  │
│             │ ────────────────────────→             │
│             │    5. Credentials      │  (2FA)      │
└─────────────┘                         └─────────────┘
       │                                        │
       │                                        │ 7. OIDC Token
       │                                        ▼
       │                                ┌─────────────┐
       └────────────────────────────────│ Application │
                8. Authenticated        │  Services   │
                                        └─────────────┘
```

## Secret Management (Vault Integration)

### Minimal Stack
- Development secrets in .env files
- Docker environment variable injection
- File-based configuration

### Full Stack  
- Centralized secret storage in Vault
- Template stanza in Nomad jobs
- Dynamic secret injection at runtime
- Rotation and versioning capabilities

```
Vault KV Store
├── secret/data/authelia-config
│   ├── jwt_secret
│   ├── session_secret
│   ├── storage_encryption_key
│   └── oidc_secrets
├── secret/data/prefect-config
│   ├── database_url
│   ├── oidc_client_secret
│   └── api_keys
└── secret/data/vault-config
    ├── oidc_client_id
    └── oidc_client_secret
```

## Network Security

### Network Isolation
- All services in dedicated Docker network
- No direct external access except through Traefik
- Inter-service communication via service names

### SSL/TLS
- Let's Encrypt automatic certificate provisioning
- HTTPS termination at Traefik
- Internal HTTP communication (encrypted at network level)

### Authentication & Authorization
- OIDC-based single sign-on
- Role-based access control
- Forward authentication middleware

## Data Persistence

### Database
- PostgreSQL with separate databases per service
- Connection pooling and optimization
- Backup and recovery strategies

### Storage Volumes
- Named Docker volumes for data persistence
- Artifact storage for ML models
- Log retention and rotation

### Configuration
- Git-based configuration management  
- Environment-specific overrides
- Secret separation from configuration

## Monitoring & Health Checks

### Service Health
- HTTP health endpoints for all services
- Docker/Nomad health checks
- Automatic restart on failure

### Observability
- Centralized logging via Docker
- Access logs from Traefik
- Metrics collection endpoints

### Alerting
- Service availability monitoring
- Resource usage tracking
- Failed authentication attempts

## Scaling Considerations

### Horizontal Scaling (Full Stack)
- Nomad job count adjustment
- Load balancing via Consul
- Service mesh integration

### Vertical Scaling
- Resource allocation tuning
- Memory and CPU optimization
- Storage capacity planning

### Performance Optimization
- Database connection pooling
- Redis caching strategies
- CDN integration for static assets