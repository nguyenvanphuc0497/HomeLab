# 🏠 HomeLab Infrastructure

![Status](https://img.shields.io/badge/Status-Building-orange?style=for-the-badge)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue?style=for-the-badge&logo=githubactions)
![Infrastructure](https://img.shields.io/badge/Infrastructure-Docker%20%26%20Proxmox-blueviolet?style=for-the-badge)

> "The cloud is just someone else's computer." - Welcome to **my** computer.

## 📖 About
This repository hosts the **Infrastructure as Code (IaC)** configuration for my personal HomeLab. The project aims to achieve data sovereignty, practice DevOps workflows (CI/CD), and manage Smart Home services efficiently.

### Workflow & Architecture
This lab operates on a **Hybrid GitOps** model:
1. **Source of Truth:** Code is version-controlled on **GitHub**.
2. **Backup Strategy:** Automated mirroring to a self-hosted **Gitea** instance (running on Raspberry Pi 4).
3. **Deployment:** Continuous Deployment (CD) via self-hosted **GitHub Actions Runners** executing directly on physical nodes.

## 🏗️ Hardware Inventory

| Device             | Role                | Specs             | OS             | Primary Services                        |
| :----------------- | :------------------ | :---------------- | :------------- | :-------------------------------------- |
| **Intel NUC**      | Virtualization Host | Core i5, 8GB RAM  | Proxmox VE     | HAOS (VM), Windows (VM)                 |
| **Raspberry Pi 5** | Compute Node        | 4GB RAM           | Ubuntu Server  | Production Containers (Media, Tools)    |
| **Raspberry Pi 4** | Management Node     | 4GB RAM           | Ubuntu Server  | Gitea, **GitHub Runner**, Reverse Proxy |
| **Raspberry Pi 3** | Management Node     | 1GB RAM           | Ubuntu Server  | Gitea, **GitHub Runner**, Reverse Proxy |
| **PC Desktop**     | Workstation         | Core i5, 16GB RAM | Ubuntu / Win10 | Development, AI Training, Staging       |

## 🚀 Roadmap

### Phase 1: Foundation 🚧
- [x] Initialize `homelab` repository on GitHub.
- [ ] Configure **SSH Key Pairs** for passwordless communication between nodes.
- [ ] Deploy **Gitea** on Raspberry Pi 4 (via Docker Compose).
- [ ] Setup **Repo Mirroring** (GitHub -> Gitea) for automated backup.

### Phase 2: Automation Pipelines ⚙️
- [ ] Provision **GitHub Actions Self-hosted Runner** on Raspberry Pi 4.
- [ ] Author basic `deploy.yml` workflow:
    - [ ] Trigger on push to `main` branch.
    - [ ] SSH tunneling from Runner to Compute Node (Pi 5).
    - [ ] Execute Docker update commands.

### Phase 3: Migration & Standardization 📦
- [ ] Audit existing container configurations on Raspberry Pi 5.
- [ ] Refactor ad-hoc `docker run` commands into `docker-compose.yml` files.
- [ ] Commit service definitions to `services/` directory.
- [ ] Integrate Home Assistant configuration into version control.

### Phase 4: Monitoring & Security 🛡️
- [ ] Deploy **Uptime Kuma** for service health monitoring.
- [ ] Setup centralized Dashboard (Homepage/Heimdall).
- [ ] Configure alert notifications (Telegram/Discord) for build failures.

## 🛠️ Tech Stack

* **Virtualization:** Proxmox VE
* **Containerization:** Docker, Docker Compose
* **CI/CD:** GitHub Actions (Self-hosted Runner)
* **SCM:** GitHub (Primary), Gitea (Backup Mirror)
* **OS:** Ubuntu Server LTS, Home Assistant OS

---
*Maintained by [NguyenVanPhuc]*
