

# 🚀 Monolith Lean Platform

## 📚 Table of Contents

- [Monolith Lean Platform](#-monolith-lean-platform)
    - [Minimal Stack (Local Development)](#-minimal-stack-local-development)
    - [Full Stack (VM Production/Staging)](#-full-stack-vm-productionstaging)
    - [Security & Access (Full Stack)](#-security--access-full-stack)
    - [Contributing](#-contributing)
    - [License](#-license)
    - [Project Structure (Monolith Lean Edition)](#-project-structure-monolith-lean-edition)
    - [Stack Directory Explanation](#-stack-directory-explanation)


![MIT License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/stack-MLOps%20%7C%20DevOps%20%7C%20Plane-blue)

> **แพลตฟอร์มแบบครบวงจร (Lean Edition):** สำหรับ MLOps, Workflow Automation (Prefect), และ Project Management (Plane) — รองรับทั้ง Local Dev และ Production VM

---

## ⚙️ Minimal Stack (Local Development)

> **เหมาะสำหรับ:** พัฒนา Flow, ทดสอบโค้ด, Proof-of-Concept (ใช้ทรัพยากรต่ำสุด)

**Requirements:**

| Resource      | Details                        |
|--------------|-------------------------------|
| CPU/RAM      | 2 Cores / 8 GB RAM (min)      |
| Database     | PostgreSQL (Lightweight)      |
| Access       | HTTP (No SSL/Authelia)        |
| Orchestration| Docker Compose                |

**Core Services:**
- Security:  Vault (Secrets)
- Orchestration: Consul
- Project Mgt: Plane
- Prefect Server (Workflow Orchestration)
- MLflow Server (Experiment Tracking)
- PostgreSQL (MLOps Metadata)
- Traefik (HTTP Routing)

**Deploy Commands:**

```bash
# Start Stack
docker compose -f docker-compose.minimal.yaml up -d

# Run Development Flow (เช่น my_flow.py)
python my_flow.py

# Stop Stack
docker compose -f docker-compose.minimal.yaml down
```

---

## 🛡️ Full Stack (VM Production/Staging)

> **เหมาะสำหรับ:** Production ที่ต้องการ Security, Scalability, Observability

**Requirements:**

| Resource      | Details                        |
|--------------|-------------------------------|
| VM Spec      | 6 Cores / 16 GB RAM (reco.)   |
| Security     | Authelia (IdP, SSO, MFA)      |
| Orchestration| Nomad + Vault (HashiStack)    |
| Access       | HTTPS (Traefik TLS)           |
| Deployment   | Ansible CLI (Control Node)    |

**Core Services:**
- Security: Authelia (IdP), Vault (Secrets)
- Orchestration: Nomad, Consul
- Project Mgt: Plane
- Observability: Loki, Prometheus, Grafana, Tempo
- All MLOps Services: Prefect, MLflow, Label Studio, n8n

**Deploy Commands (Ansible):**

```bash
# Provisioning & Base Setup
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/02_base_setup.yml

# Initialize Vault & Inject Secrets (CRITICAL)
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/04_vault_init.yml
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/05_vault_config.yml

# Deploy Full Services Stack (Docker Compose)
ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/07_full_stack_deploy.yml

# Submit Nomad Workloads (Vault Token required)
nomad job run config/nomad/prefect-server.nomad
nomad job run config/nomad/plane-app.nomad
# ... และ Jobs อื่นๆ ทั้งหมด
```

---

# 🚀 Integrated Platform: Deployment Guide (Minimal vs. Full)

[](https://www.google.com/search?q=LICENSE)
[](https://www.google.com/search?q=https://github.com/yourusername/yourrepo)

โครงการนี้คือแพลตฟอร์มแบบครบวงจร (Lean Edition) ที่เน้นประสิทธิภาพด้านทรัพยากรสูงสำหรับการทำงานด้าน **MLOps, Workflow Automation (Prefect)**, และ **Project Management (Plane)** เราได้แบ่งวิธีการ Deploy ออกเป็น 2 โหมดหลักเพื่อรองรับการทำงานในทุกสภาพแวดล้อม:

1.  **Minimal Stack:** สำหรับการพัฒนาบนเครื่อง Local ที่มีทรัพยากรจำกัด
2.  **Full Stack:** สำหรับ Production/Staging บน VM ที่มี Security และ Orchestration ครบถ้วน

-----

## 1\. ⚙️ Minimal Stack (Local Development)

**วัตถุประสงค์:** ใช้สำหรับการพัฒนา Flow, ทดสอบโค้ด, และการทำ Proof-of-Concept โดยใช้ทรัพยากรต่ำสุด

### 💻 Prerequisites & Environment

| ทรัพยากรที่ต้องการ | รายละเอียด |
| :--- | :--- |
| **CPU/RAM** | **2 Cores / 8 GB RAM** (Minimum) |
| **Database** | PostgreSQL (Lightweight Configuration) |
| **Access** | HTTP (ไม่มี SSL/Authelia) |
| **Orchestration** | **Docker Compose** |

### Core Services (Minimal)

Stack นี้จะรันเฉพาะ Services ที่จำเป็นต่อการพัฒนา:

  * **Prefect Server:** Workflow Orchestration Engine.
  * **MLflow Server:** Experiment Tracking.
  * **PostgreSQL:** ฐานข้อมูลหลักสำหรับ MLOps Metadata.
  * **Traefik (HTTP):** Basic Routing.

### 🚀 คำสั่งในการ Deploy (Local)

ใช้ไฟล์ `docker-compose.minimal.yaml` ในการ Start/Stop Services:

1.  **Start Stack:**
    ```bash
    docker compose -f docker-compose.minimal.yaml up -d
    ```
2.  **Run Development Flow:** (สมมติว่าไฟล์ `my_flow.py` อยู่ใน Path ที่เข้าถึงได้)
    ```bash
    python my_flow.py
    ```
3.  **Stop Stack:**
    ```bash
    docker compose -f docker-compose.minimal.yaml down
    ```

-----

## 2\. 🛡️ Full Stack (VM Production/Staging)

**วัตถุประสงค์:** สภาพแวดล้อม Production ที่มี Security, Scalability, และ Observability ครบถ้วน

### 💻 Prerequisites & Environment

| ทรัพยากรที่ต้องการ | รายละเอียด |
| :--- | :--- |
| **VM Spec** | **6 Cores / 16 GB RAM** (Recommended) |
| **Security** | **Authelia** (IdP, SSO, MFA/Passkey) |
| **Orchestration** | **Nomad + Vault** (HashiStack) |
| **Access** | HTTPS (Traefik ทำ TLS) |
| **Deployment** | **Ansible CLI** (Control Node) |

### Core Services (Full)

Stack นี้ประกอบด้วย Services ทั้งหมด (รวมถึง Services ที่ถูกตัดออกจาก Minimal Stack):

  * **Security:** **Authelia** (IdP), **Vault** (Secret Management).
  * **Orchestration:** **Nomad, Consul.**
  * **Project Mgt:** **Plane.**
  * **Observability:** **Loki, Prometheus, Grafana, Tempo.**
  * **All MLOps Services:** Prefect, MLflow, Label Studio, n8n.

### 🚀 คำสั่งในการ Deploy (บน VM ผ่าน Ansible)

การ Deploy Full Stack ต้องผ่าน **Ansible Playbooks** เพื่อจัดการ Vault Secrets และ Orchestration อย่างปลอดภัย

1.  **Provisioning & Base Setup:**
    ```bash
    ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/02_base_setup.yml
    ```
2.  **Initialize Vault & Inject Secrets:** (CRITICAL STEP)
    ```bash
    ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/04_vault_init.yml
    ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/05_vault_config.yml
    ```
3.  **Deploy Full Services Stack (Docker Compose):** Deploy Core Services, Security, และ Project Services
    ```bash
    ansible-playbook -i ansible/inventory/hosts.yml ansible/playbooks/07_full_stack_deploy.yml
    ```
4.  **Submit Nomad Workloads:** (รันจาก Local CLI ที่มีสิทธิ์ Vault Token)
    ```bash
    nomad job run config/nomad/prefect-server.nomad
    nomad job run config/nomad/plane-app.nomad
    # ... และ Jobs อื่นๆ ทั้งหมด
    ```

-----

## 🔑 Security & Access (Full Stack)

ทุก Services ใน **Full Stack** ถูกป้องกันโดย **Authelia** (SSO, MFA, Passkey/WebAuthn)

| Service   | URL                        | Authentication   |
|-----------|----------------------------|------------------|
| Plane     | https://plane.yourdomain.com   | Authelia SSO    |
| Prefect   | https://prefect.yourdomain.com | Authelia SSO    |
| Grafana   | https://grafana.yourdomain.com | Authelia SSO    |

---

## 🤝 Contributing

ยินดีรับทุกข้อเสนอแนะ! หากต้องการปรับปรุง Minimal Stack หรือ Nomad Job Specs สำหรับ Full Stack โปรดเปิด [Issue](https://github.com/yourusername/yourrepo/issues) หรือ [Pull Request](https://github.com/yourusername/yourrepo/pulls)

## 📄 License

Distributed under the [MIT License](LICENSE).

---

## 🔑 Security & Access

ทุก Services ใน **Full Stack** ถูกป้องกันโดย **Authelia** เพื่อบังคับใช้ Single Sign-On (SSO) และ Multi-Factor Authentication (MFA) รวมถึงการรองรับ **Passkey/WebAuthn**

| Service | URL (ผ่าน Traefik) | Authentication |
| :--- | :--- | :--- |
| **Plane** | `https://plane.yourdomain.com` | Authelia SSO |
| **Prefect** | `https://prefect.yourdomain.com` | Authelia SSO |
| **Grafana** | `https://grafana.yourdomain.com` | Authelia SSO |

-----

## 🤝 Contributing

ยินดีรับทุกข้อเสนอแนะ\! หากคุณต้องการปรับปรุงการตั้งค่า Minimal Stack หรือปรับปรุง Nomad Job Specs สำหรับ Full Stack โปรดเปิด [Issue](https://www.google.com/search?q=https://github.com/yourusername/yourrepo/issues) หรือ [Pull Request](https://www.google.com/search?q=https://github.com/yourusername/yourrepo/pulls)

## 📄 License

โครงการนี้อยู่ภายใต้ลิขสิทธิ์ [MIT License](https://www.google.com/search?q=LICENSE)
-----

## 📁 Project Structure (Monolith Lean Edition)

> โครงสร้างนี้ออกแบบให้ `ansible` และ `docker-compose` อ้างอิงไฟล์ใน `config` และ `data` ได้ง่าย

```
monolith-lean-platform/
├── .gitignore                      # Ignore rules (e.g., /data/, *.env, Vault Tokens)
├── README.md                       # Project overview & guides
├── LICENSE                         # License
│
├── docker-compose/                 # Docker Compose files (per stack)
│   ├── docker-compose.minimal.yaml # For Local Dev (Prefect, MLflow, DB)
│   └── docker-compose.full.yaml    # For VM Prod (used by Ansible)
│
├── ansible/                        # Provisioning & VM config (Full Stack)
│   ├── inventory/
│   │   └── hosts.yml               # VM IP/User
│   ├── roles/                      # (Optional) reusable roles
│   ├── playbooks/                  # Main deploy playbooks
│   └── vault/
│       └── project_secrets.yml     # Encrypted secrets (Ansible Vault)
│
├── config/                         # All service configs
│   ├── authelia/                   # Authelia config & rules
│   ├── nomad/                      # Nomad job specs (*.nomad)
│   ├── vault/                      # Vault policies & setup
│   ├── traefik/                    # Traefik routers, middlewares, TLS
│   ├── postgres/                   # PostgreSQL config (schemas, etc.)
│   └── grafana/                    # Grafana configs & dashboards
│
├── app/                            # Main app code (backend/frontend)
│   ├── backend/
│   └── frontend/
│
├── prefect_flows/                  # Prefect Flows (Python)
│   ├── ci_cd_flows.py              # CI/CD flows
│   └── mlops_flows.py              # MLOps pipelines
│
└── data/                           # Persistent storage volumes
    ├── postgres/                   # DB data
    ├── vault/                      # Vault storage backend
    ├── minio/                      # MinIO artifacts
    └── prometheus/                 # Metrics data
```

---

## 💡 Stack Directory Explanation

**1. Shared Configuration**
- `/config`: Central for all configs. Minimal Stack uses only Prefect, MLflow, Traefik configs, but Full Stack can reuse all.

**2. Deployment Separation**
- `/docker-compose`: For Minimal Stack (local dev). `.minimal.yaml` mounts only needed volumes.
- `/ansible`: For Full Stack (VM/Prod). Playbooks use `docker-compose.full.yaml` and `nomad job run` for workloads.

**3. Application Logic**
- `/prefect_flows`: Python logic for Prefect Agent (local or Nomad). Decoupled for easy testing.

