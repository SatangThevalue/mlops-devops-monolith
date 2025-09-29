## 🏗️ PHASE 0: FOUNDATION SETUP (งานพื้นฐาน) @Phase0

### 🟢 To Do / Not Started

- [X] **0.0 FOUNDATION SETUP (Goal)**
- [X] 0.1 ออกแบบโครงสร้าง Repository และโฟลเดอร์หลัก @BothStacks
- [X] 0.2 ติดตั้ง Prerequisite บน Local (Docker, Ansible CLIs) @BothStacks
- [X] 0.3 กำหนดค่า Secret และเข้ารหัสด้วย Ansible Vault @FullStack
- [X] 0.4 สร้าง Base Playbook สำหรับติดตั้ง Docker บน VM @FullStack

---

## 💻 PHASE 1: MINIMAL STACK (Local Dev) @Phase1

### 🟢 To Do / Not Started

- [ ] **1.0 MINIMAL STACK IMPLEMENTATION (Goal)**
- [ ] 1.1 กำหนดค่า Services หลัก: DB, Prefect, MLflow, Traefik @MinimalStack
- [ ] 1.2 สร้าง Prefect Flow Template สำหรับทดสอบ (E2E) @MinimalStack
- [ ] 1.3 ทดสอบ End-to-End Local: Start Stack และรัน Flow @MinimalStack
- [ ] 1.4 กำหนดค่า Plane Service ใน `minimal.yaml` @MinimalStack

### 🔴 Blocked (ผลลัพธ์)

- [ ] 1.9 **ผลลัพธ์: ระบบรัน Flow และบันทึกผลได้บน Local** (ปลดบล็อกเมื่อ 1.1-1.4 เสร็จสิ้น)

---

## 🛡️ PHASE 2: FULL STACK (VM Production) @Phase2

### 🟢 To Do / Not Started

- [ ] **2.0 FULL STACK DEPLOYMENT (Goal)**@BothStacks
- [ ] 2.1 กำหนดค่า HashiStack (Vault/Nomad/Consul) Config @FullStack
- [ ] 2.2 กำหนดค่า Security (Authelia) Config และ Rules (OIDC) @FullStack
- [ ] 2.3 สร้าง Playbook: Vault Init/Config (Policy, Inject Secrets) @FullStack
- [ ] 2.4 สร้าง Job Specs (Nomad) สำหรับ Prefect, Plane, MLflow, ฯลฯ @FullStack
- [ ] 2.5 กำหนดค่า Observability (LGTM): Prometheus Targets, Loki Scraping @FullStack
- [ ] 2.6 Deploy Full Services Stack (ผ่าน Ansible) @FullStack
- [ ] 2.7 ทดสอบ End-to-End Production (SSO, Nomad, Metrics) @FullStack

### 🔴 Blocked (ผลลัพธ์)

- [ ] 2.9 **ผลลัพธ์: ระบบ Production สมบูรณ์** (ปลดบล็อกเมื่อ 2.1-2.7 เสร็จสิ้น)
