# 📅 Project Roadmap & Task Planning Template (Minimal vs. Full Stack)

เทมเพลตนี้ถูกออกแบบมาเพื่อติดตามงานสำหรับการสร้าง Integrated Platform โดยแบ่งเป็น 3 เฟสหลัก และระบุ Stack ที่เกี่ยวข้อง

## 🎯 โครงสร้าง Database หลัก (Tasks)

| ชื่อ Task (Task Name) | เฟส (Phase) | Stack ที่เกี่ยวข้อง | สถานะ (Status) | ลำดับ (Order) | ผู้รับผิดชอบ (Assignee) | วันที่เริ่มต้น (Start Date) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **0. FOUNDATION SETUP** | **Phase 0** | ทั้งคู่ | Not started | 0.0 | | |
| ออกแบบโครงสร้าง Repository และโฟลเดอร์หลัก | Phase 0 | ทั้งคู่ | Not started | 0.1 | | |
| ติดตั้ง Prerequisite บน Local (Docker, Ansible CLIs) | Phase 0 | ทั้งคู่ | Not started | 0.2 | | |
| กำหนดค่า Secret และเข้ารหัสด้วย Ansible Vault | Phase 0 | Full | Not started | 0.3 | | |
| สร้าง Base Playbook สำหรับติดตั้ง Docker บน VM | Phase 0 | Full | Not started | 0.4 | | |
| --- | --- | --- | --- | --- | --- | --- |
| **1. MINIMAL STACK IMPLEMENTATION (Local Dev)** | **Phase 1** | Minimal | Not started | 1.0 | | |
| กำหนดค่า Services หลัก: DB, Prefect, MLflow, Traefik | Phase 1 | Minimal | Not started | 1.1 | | |
| สร้าง Prefect Flow Template สำหรับทดสอบ (E2E) | Phase 1 | Minimal | Not started | 1.2 | | |
| ทดสอบ End-to-End Local: Start Stack และรัน Flow | Phase 1 | Minimal | Not started | 1.3 | | |
| กำหนดค่า Plane Service ใน `minimal.yaml` | Phase 1 | Minimal | Not started | 1.4 | | |
| **ผลลัพธ์: ระบบรัน Flow และบันทึกผลได้บน Local** | Phase 1 | Minimal | Blocked | 1.9 | | |
| --- | --- | --- | --- | --- | --- | --- |
| **2. FULL STACK DEPLOYMENT (VM Production)** | **Phase 2** | Full | Not started | 2.0 | | |
| กำหนดค่า HashiStack (Vault/Nomad/Consul) Config | Phase 2 | Full | Not started | 2.1 | | |
| กำหนดค่า Security (Authelia) Config และ Rules (OIDC) | Phase 2 | Full | Not started | 2.2 | | |
| สร้าง Playbook: Vault Init/Config (Policy, Inject Secrets) | Phase 2 | Full | Not started | 2.3 | | |
| สร้าง Job Specs (Nomad) สำหรับ Prefect, Plane, MLflow, ฯลฯ | Phase 2 | Full | Not started | 2.4 | | |
| กำหนดค่า Observability (LGTM): Prometheus Targets, Loki Scraping | Phase 2 | Full | Not started | 2.5 | | |
| Deploy Full Services Stack (ผ่าน Ansible) | Phase 2 | Full | Not started | 2.6 | | |
| ทดสอบ End-to-End Production (SSO, Nomad, Metrics) | Phase 2 | Full | Not started | 2.7 | | |
| **ผลลัพธ์: ระบบ Production สมบูรณ์** | Phase 2 | Full | Blocked | 2.9 | | |

---

## 💡 วิธีการนำไปใช้ใน Notion

1.  **คัดลอกทั้งหมด:** คัดลอกตาราง Markdown ด้านบนทั้งหมด
2.  **วางใน Notion:** วางลงในหน้า Notion ใหม่
3.  **สร้าง Database:** Notion จะถามว่าคุณต้องการ "Dismiss" หรือ "Create Database" ให้เลือก **"Create Database"**
4.  **ปรับปรุงคุณสมบัติ:** Notion จะสร้างตารางตามที่คุณกำหนด คุณสามารถเปลี่ยน Type ของคอลัมน์ได้:
    * **Status:** เปลี่ยนเป็น **Select** (มีค่า: Not started, In progress, Done)
    * **Phase/Stack:** เปลี่ยนเป็น **Select** (สำหรับจัดกลุ่ม)

### มุมมองที่แนะนำใน Notion

* **Roadmap View (Board):** จัดกลุ่มตามคุณสมบัติ **Phase** เพื่อดูความคืบหน้าของแต่ละเฟส
* **Kanban View (Board):** จัดกลุ่มตาม **Status** เพื่อติดตามสถานะของแต่ละ Task
* **Gantt View (Timeline):** จัดกลุ่มตาม **Stack** และใช้ **Start Date** เพื่อดูแผนงานตามลำดับเวลา

เทมเพลตนี้จะช่วยให้ทีมของคุณเห็นภาพรวมว่างานใดที่ต้องทำบน Local ก่อน และงานใดที่ต้อง Deploy ขึ้น VM ในภายหลังครับ!