# Copilot AI Agent Instructions for Monolith Lean Platform

## Project Overview
This repository is a monolithic, resource-efficient platform for MLOps, workflow automation (Prefect), and project management (Plane). It supports both minimal local development and full-stack production deployments.

## Architecture & Structure
- **Minimal Stack**: For local dev, uses Docker Compose to run only essential services (Prefect, MLflow, PostgreSQL, Traefik, Vault, Plane, Consul).
- **Full Stack**: For production/staging, uses Ansible for provisioning, Vault for secrets, Nomad for orchestration, and includes observability (Loki, Prometheus, Grafana, Tempo), Authelia for SSO/MFA, and more MLOps tools (Label Studio, n8n).
- **Config Reuse**: All service configs are centralized in `/config` for both stacks. Minimal stack uses a subset; full stack reuses all.
- **Directory Conventions**:
  - `/docker-compose/`: Compose files for minimal/full stack
  - `/ansible/`: Playbooks, inventory, and secrets for full stack
  - `/config/`: Service configs (authelia, nomad, vault, traefik, postgres, grafana)
  - `/prefect_flows/`: Python flows for Prefect (decoupled from infra)
  - `/data/`: Persistent volumes (db, vault, minio, prometheus)

## Developer Workflows
- **Local Dev**: Use `docker compose -f docker-compose.minimal.yaml up -d` to start, and `down` to stop. Run flows with `python my_flow.py`.
- **Production Deploy**: Use Ansible playbooks in `/ansible/playbooks/` for provisioning, vault init, and stack deploy. Submit Nomad jobs from CLI with Vault token.
- **Secrets**: Managed via Vault. For full stack, always run vault init/config playbooks before deploying services.
- **Observability**: Access via Grafana, Prometheus, Loki, Tempo (see Traefik routes in config).

## Patterns & Conventions
- **Service Boundaries**: Each service has its own config in `/config/{service}/`. Compose and Nomad specs mount these as needed.
- **Python Flows**: Place all Prefect flows in `/prefect_flows/`. Flows should not depend on infrastructure details.
- **Data Volumes**: All persistent data is under `/data/{service}/` and is mounted by Compose/Nomad.
- **Security**: Full stack is always behind Authelia SSO/MFA. Minimal stack is open (HTTP only, no SSO).
- **Extending**: Add new services by creating config in `/config/`, updating Compose/Nomad specs, and (for full stack) updating Ansible playbooks.

## Examples
- To add a new Prefect flow: place a Python file in `/prefect_flows/` and run it with the appropriate stack running.
- To add a new service: add config under `/config/{service}/`, update Compose/Nomad, and ensure data volume is mapped under `/data/{service}/`.

## Key Files
- `README.md`: Full architecture, stack usage, and directory explanation
- `/docker-compose/docker-compose.minimal.yaml`: Minimal stack definition
- `/docker-compose/docker-compose.full.yaml`: Full stack definition
- `/ansible/playbooks/`: Ansible automation for full stack
- `/config/`: All service configs
- `/prefect_flows/`: Prefect flow code

---
If you are unsure about a workflow or pattern, check the latest `README.md` or the relevant config/playbook for up-to-date conventions.
