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
    nomad job run config/nomครับ\! การแยกไฟล์ `README.md` ตามประเภท Stack (Minimal และ Full) จะช่วยให้ผู้ใช้เข้าใจวิธีการ Deploy และข้อจำกัดของแต่ละสภาพแวดล้อมได้อย่างชัดเจนยิ่งขึ้น นี่คือโครงสร้างและเนื้อหาที่ถูกออกแบบตามมาตรฐานของ GitHub สำหรับโปรเจกต์ของคุณครับ

-----

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

โครงการนี้อยู่ภายใต้ลิขสิทธิ์ [MIT License](https://www.google.com/search?q=LICENSE)ad/plane-app.nomad
    # ... และ Jobs อื่นๆ ทั้งหมด
    ```

-----

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

## 📁 โครงสร้างโฟลเดอร์โปรเจกต์ (Monolith Lean Edition)

โครงสร้างนี้ถูกออกแบบมาเพื่อให้ `ansible` และ `docker-compose` สามารถอ้างอิงถึงไฟล์ในโฟลเดอร์ `config` และ `data` ได้อย่างง่ายดาย

```
monolith-lean-platform/
├── .gitignore                      # ไฟล์สำหรับละเว้น (e.g., /data/, *.env, Vault Tokens)
├── README.md                       # รายละเอียดโปรเจกต์รวม (Link ไป Minimal/Full Guide)
├── LICENSE                         # ลิขสิทธิ์
|
├── docker-compose/                 # ไฟล์ Docker Compose หลัก แยกตาม Stack
│   ├── docker-compose.minimal.yaml # ไฟล์สำหรับ Local Dev (Prefect, MLflow, DB)
│   └── docker-compose.full.yaml    # ไฟล์สำหรับ VM Prod (ใช้โดย Ansible)
|
├── ansible/                        # โค้ดสำหรับ Provisioning และ Config VM (Full Stack)
│   ├── inventory/
│   │   └── hosts.yml               # กำหนด IP/User ของ VM
│   ├── roles/                      # (Optional) สำหรับงานที่ซ้ำซ้อน
│   ├── playbooks/                  # ไฟล์คำสั่งหลักในการ Deploy (01_base_setup, 07_full_deploy, etc.)
│   └── vault/
│       └── project_secrets.yml     # Secrets ที่ถูกเข้ารหัสด้วย Ansible Vault
|
├── config/                         # ไฟล์ Config สำหรับ Services ทั้งหมด
│   ├── authelia/                   # Configuration ของ Authelia และ Rules
│   ├── nomad/                      # Nomad Job Specifications (*.nomad)
│   ├── vault/                      # Vault Policies และ Initial Setup Config
│   ├── traefik/                    # Traefik Routers, Middlewares, และ TLS
│   ├── postgres/                   # Config สำหรับ PostgreSQL (e.g., initial schemas)
│   └── grafana/                    # Configs และ Dashboards สำหรับ Grafana
|
├── app/                            # โค้ดแอปพลิเคชันหลัก (Backend/Frontend - ถ้ามี)
│   ├── backend/
│   └── frontend/
|
├── prefect_flows/                  # โค้ด Prefect Flows (Python)
│   ├── ci_cd_flows.py              # Flows สำหรับ CI/CD Tasks
│   └── mlops_flows.py              # Flows สำหรับ MLOps Pipelines
|
└── data/                           # Persistent Storage Volumes
    ├── postgres/                   # ข้อมูล DB
    ├── vault/                      # ข้อมูล Vault (Storage Backend)
    ├── minio/                      # ข้อมูล MinIO (Artifacts)
    └── prometheus/                 # ข้อมูล Metrics
```

-----

## 💡 คำอธิบายการแยกโฟลเดอร์ตาม Stack

### 1\. การจัดการ Configuration (ใช้ร่วมกัน)

  * **`/config`**: โฟลเดอร์นี้เป็นศูนย์กลางของไฟล์ Configs ทั้งหมด แม้ว่า **Minimal Stack** จะใช้เพียงแค่ Config ของ **Prefect, MLflow, และ Traefik** แต่การเก็บไฟล์ทั้งหมดไว้ที่นี่ทำให้ **Full Stack** สามารถอ้างอิงไฟล์เดียวกันได้ง่ายขึ้นเมื่อ Deploy ด้วย Ansible หรือ Nomad

### 2\. การจัดการ Deployment (แยกกัน)

  * **`/docker-compose`**: รับผิดชอบการรันแบบ **Minimal Stack** โดยตรง
      * **`.minimal.yaml`** จะกำหนด `volumes` ให้เชื่อมต่อกับ Services ที่ต้องการใน `/config` และ `/data` (เช่น PostgreSQL)
  * **`/ansible`**: รับผิดชอบการรันแบบ **Full Stack**
      * Playbooks จะใช้ `docker compose -f docker-compose.full.yaml up` เพื่อ Deploy Infrastructure Services และใช้คำสั่ง `nomad job run` เพื่อ Deploy Application Workloads

### 3\. Application Logic (แยกกัน)

  * **`/prefect_flows`**: เป็นที่เก็บ Python Logic ที่ถูกรันโดย **Prefect Agent** (ซึ่งรันอยู่บน Local ใน Minimal Stack และบน Nomad ใน Full Stack) การแยก Flow ออกมาทำให้สามารถทดสอบ Logic ได้ง่ายโดยไม่ขึ้นกับ Infrastructure

