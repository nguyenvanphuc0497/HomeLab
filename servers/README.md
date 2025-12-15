# 🖥️ Servers Directory

This directory contains **per-server Docker Compose configurations** organized by hardware architecture and role. Each subdirectory represents a physical node in the HomeLab infrastructure.

## 📁 Directory Structure

```
servers/
├── raspi3/          # Raspberry Pi 3 (armv7, 1GB RAM) - Management Node
├── raspi4/          # Raspberry Pi 4 (arm64, 4GB RAM) - Management Node
├── raspi5/          # Raspberry Pi 5 (arm64, 4GB RAM) - Compute Node
├── intel-nuc/       # Intel NUC (amd64, 8GB RAM) - Virtualization Host
└── amd-ovm/         # AMD OVM (amd64) - Virtualization Host
```

Each server directory contains:
- `docker-compose.yml` - Service definitions for this node
- `env.example` - Template for environment variables (copy to `.env`)
- `Makefile` - Quick commands for deployment and management
- `README.md` - Server-specific documentation

## 🚀 Quick Start

### 1. Choose Your Server

Navigate to the server directory you want to deploy:

```bash
cd servers/raspi5  # Example: Raspberry Pi 5
```

### 2. Setup Environment Variables

**⚠️ IMPORTANT:** Never commit `.env` files! They contain secrets.

```bash
# Copy the example template
cp env.example .env

# Edit .env with your actual values
nano .env  # or vim/vi
```

Required variables (see `env.example` for full list):
- `HOSTNAME` - Server hostname
- `TZ` - Timezone (e.g., `Asia/Ho_Chi_Minh`)
- `DATA_ROOT` - Base path for persistent data
- `PUID`/`PGID` - User/group IDs for file permissions

### 3. Validate Configuration

Check that your `docker-compose.yml` is valid:

```bash
make check
```

### 4. Deploy Services

Pull latest images and start containers:

```bash
make deploy
```

Or step by step:
```bash
make pull   # Pull images
make up     # Start containers
```

### 5. Monitor Services

```bash
make logs   # Follow logs (tail -f)
make ps     # List running containers
```

## 🛠️ Makefile Commands

Each server includes a `Makefile` with common operations:

### Validation & Testing (MacBook/Local)

| Command | Description |
|---------|-------------|
| `make check` | Validate docker-compose.yml syntax (works without .env) |
| `make dry-run` | Preview what would be deployed (no actual deploy) |
| `make test-deploy` | **Test deploy with platform emulation** (MacBook) |
| `make test-down` | Stop test containers after test-deploy |
| `make pull-test` | Pull images for target platform (emulation) |

### Production Deployment (Server)

| Command | Description |
|---------|-------------|
| `make deploy` | Pull images + start containers (recommended) |
| `make up` | Start containers in detached mode |
| `make down` | Stop and remove containers |
| `make pull` | Pull latest images |
| `make logs` | Follow logs (last 100 lines) |
| `make ps` | List running containers |
| `make restart` | Restart all services |

### Custom Compose File

To use a different compose file:

```bash
make deploy STACK=custom-compose.yml
make test-deploy STACK=custom-compose.yml PLATFORM=linux/arm64
```

## 🧪 Testing on MacBook (Development)

You can test deployments on your MacBook **even if the platform differs** (e.g., testing ARM64 compose files on Intel Mac):

### 1. Preview Deployment (Dry Run)

```bash
cd servers/raspi5
make dry-run
```

Shows:
- Services that would be deployed
- Images that would be pulled
- Validates configuration syntax

### 2. Test Deploy (With Platform Emulation)

```bash
cd servers/raspi5
make test-deploy    # Deploys with ARM64 emulation
make logs           # Check logs
make test-down      # Clean up when done
```

**How it works:**
- Uses Docker's platform emulation (`DOCKER_DEFAULT_PLATFORM`)
- Pulls ARM64 images even on Intel Mac (via QEMU)
- Containers run with emulation (slower, but functional for testing)

**Requirements:**
- Docker Desktop with emulation enabled (usually automatic)
- `.env` file (copy from `env.example` for testing)

### 3. Using Test Script

From repo root:

```bash
# Preview
./scripts/test-deploy.sh raspi5 dry-run

# Test deploy (with confirmation)
./scripts/test-deploy.sh raspi5 test-deploy

# Clean up
./scripts/test-deploy.sh raspi5 test-down
```

## 🏗️ Architecture-Specific Notes

### ARM Devices (Raspberry Pi)

- **Raspi 3**: `armv7` (32-bit) - Limited resources, lightweight services only
- **Raspi 4/5**: `arm64` (64-bit) - Full container support, production workloads

All ARM compose files specify `platform: linux/arm64` or `linux/arm/v7` to ensure correct image selection.

### x86_64 Devices (Intel/AMD)

- **Intel NUC**: Proxmox VE host, VMs for HAOS/Windows
- **AMD OVM**: Additional virtualization capacity

Compose files use `platform: linux/amd64` or omit platform (defaults to host).

## 🔒 Security Best Practices

1. **Never commit `.env` files** - They're gitignored for a reason!
2. **Use `env.example` as template** - Shows structure without exposing secrets
3. **Rotate secrets regularly** - Especially API keys, tokens, passwords
4. **Limit SSH access** - Use key-based auth, disable password login
5. **Review compose files** - Check volume mounts, exposed ports, network settings

## 📝 Adding a New Service


### 1. Define the Service (Once)

Create `services/<name>/docker-compose.yml`. This file should be **architecture-independent** if possible.

### 2. Add to Server (Usage)

In `servers/<server>/docker-compose.yml`, just **include** it:

```yaml
include:
  - ../../services/new-service/docker-compose.yml
```

### 3. Configure Env

Add necessary variables to `servers/<server>/env.example` and your local `.env`.

This keeps server manifests clean and services reusable!

## 🔄 CI/CD Integration

GitHub Actions workflows can deploy to these servers via:
- SSH connection from self-hosted runner
- Running `make deploy` in the appropriate server directory
- Environment-specific secrets stored in GitHub Actions secrets

See `.github/workflows/` for deployment automation (planned).

## 📚 Server-Specific Documentation

Each server has its own README with:
- Hardware specifications
- Assigned services/roles
- Architecture-specific configuration notes
- Troubleshooting tips

Check individual server directories for details:
- [`raspi3/README.md`](./raspi3/README.md)
- [`raspi4/README.md`](./raspi4/README.md)
- [`raspi5/README.md`](./raspi5/README.md)
- [`intel-nuc/README.md`](./intel-nuc/README.md)
- [`amd-ovm/README.md`](./amd-ovm/README.md)

---

**Next Steps:** Read the README in your target server directory for specific setup instructions.

