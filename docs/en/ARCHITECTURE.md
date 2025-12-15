# 🏗️ Architecture Design

This document describes the architectural philosophy of the HomeLab repository. We adopted a **Service-Oriented Infrastructure** design to ensure scalability, maintainability, and reusability.

## Core Concepts

### 1. Separation of Concerns (Services vs. Servers)

We distinguish between definition (WHAT) and deployment (WHERE).

- **`services/` (The "What")**:
  - Contains **pure service definitions** (Docker Compose files).
  - Independent of physical hardware.
  - Defines: Container image, ports (internal), volumes, dependencies.
  - *Example:* `services/gitea` defines how Gitea runs generally.

- **`servers/` (The "Where")**:
  - Contains **deployment configurations** for specific nodes (e.g., `raspi4`, `intel-nuc`).
  - Uses Docker Compose `include` to import services.
  - Defines: Environment variables, node-specific overrides.
  - *Example:* `servers/raspi4` imports `services/gitea` and sets the password.

### 2. Benefits of this Design

#### ✅ Reusability (DRY - Don't Repeat Yourself)
If you want to move a service (e.g., Gitea) from Raspberry Pi 4 to Pi 5:
- **Old way:** Copy/paste hundreds of YAML lines.
- **New way:** Simple one-line change in the `include` section.

#### 🧘 Cleanliness
Node configurations are distinct. A server running 10 services has a 20-line `docker-compose.yml` instead of a 500-line spaghetti file.

#### 🧩 Modularity
Each service is a module. You can upgrade, test, and debug the "Gitea module" without touching the "Home Assistant module".

## Directory Structure Example

```text
.
├── services/               # 🧩 Reusable Service Modules
│   └── gitea/
│       └── docker-compose.yml  # Base definition
│
└── servers/                # 📍 Physical Node Deployments
    └── raspi4/
        ├── docker-compose.yml  # Includes ../../services/gitea
        └── .env                # Secrets for this node
```

## How to add a new service

1.  **Define it**: Create `services/<name>/docker-compose.yml`.
2.  **Deploy it**: Add it to `servers/<node>/docker-compose.yml` under `include`.
