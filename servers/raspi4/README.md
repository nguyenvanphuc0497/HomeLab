# 🍓 Raspberry Pi 4 - Management Node

**Architecture:** ARM64 (64-bit)  
**RAM:** 4GB  
**Role:** Management Node (GitOps Hub)  
**OS:** Ubuntu Server LTS

## 📋 Overview

Raspberry Pi 4 is the **central management node** for the HomeLab infrastructure. It hosts critical GitOps components:

- **Gitea** - Self-hosted Git server (backup mirror)
- **GitHub Actions Runner** - Self-hosted CI/CD executor
- **Reverse Proxy** - Caddy/Traefik for service routing
- **Management Tools** - Monitoring, dashboards

## 🏗️ Architecture

- **Platform:** `linux/arm64` (64-bit ARM)
- **CPU:** ARM Cortex-A72 (quad-core, 1.8GHz)
- **Storage:** MicroSD or USB SSD (recommended for Gitea)

## 🚀 Setup

### 1. Prerequisites

```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker compose version

# Verify SSH access (for GitHub Actions Runner)
ssh-keygen -t ed25519 -C "raspi4-runner"
```

### 2. Environment Configuration

```bash
cd servers/raspi4
cp env.example .env
nano .env  # Edit with your values
```

**Required Variables:**
```bash
HOSTNAME=raspi4
TZ=Asia/Ho_Chi_Minh
DOMAIN_SUFFIX=.lan
DATA_ROOT=/srv/homelab/raspi4
PUID=1000
PGID=1000
UMASK=002
```

**Additional Variables (from root `env.example`):**
- `GITEA_URL` - Gitea instance URL
- `GITHUB_RUNNER_TOKEN` - GitHub Actions runner registration token
- `GITHUB_REPO` - Repository URL for runner

### 3. Deploy

```bash
make check   # Validate configuration
make deploy  # Pull images and start services
```

## 📦 Core Services

### Gitea (Git Server)

Self-hosted Git repository mirror for backup and local access.

**Configuration:**
- Data stored in `${DATA_ROOT}/gitea`
- Accessible at `http://raspi4:3000` (or via reverse proxy)
- Mirror sync from GitHub (configured in Gitea UI)

### GitHub Actions Runner

Self-hosted runner executes CI/CD workflows directly on the Pi.

**Setup Steps:**
1. Register runner with GitHub (see `runner/` directory scripts)
2. Runner connects to GitHub, executes jobs
3. Can SSH to other nodes (Pi5, NUC) for deployment

**Security:**
- Runner runs in isolated container or systemd service
- SSH keys stored securely (not in Git)
- Limited permissions (deploy-only user)

### Reverse Proxy

Routes external traffic to internal services.

**Options:**
- **Caddy** - Automatic HTTPS, simple config
- **Traefik** - Docker labels, advanced routing

## 🔄 GitOps Workflow

```
Developer → git push → GitHub
                         ↓
                    Gitea Mirror (backup)
                         ↓
              GitHub Actions (triggered)
                         ↓
         Self-hosted Runner (this Pi)
                         ↓
              SSH to Pi5/NUC → Deploy
```

## 🛠️ Management Commands

```bash
make logs      # View logs
make ps        # Check running containers
make restart   # Restart all services
make down      # Stop services (careful: stops GitOps!)
```

## 🔧 Troubleshooting

### Runner Not Connecting

1. Check runner status:
   ```bash
   docker ps | grep runner
   docker logs <runner-container>
   ```

2. Verify GitHub token is valid
3. Check network connectivity to GitHub

### Gitea Mirror Sync Issues

1. Check Gitea logs:
   ```bash
   docker logs gitea
   ```

2. Verify mirror configuration in Gitea UI
3. Check GitHub token permissions

### High Resource Usage

Monitor with:
```bash
docker stats
htop
```

If overloaded:
- Move non-critical services to Pi5
- Optimize Gitea settings (reduce workers)
- Use lighter reverse proxy (Caddy vs Traefik)

## 🔒 Security Considerations

- **SSH Keys:** Store deploy keys securely, never commit
- **Runner Permissions:** Use least-privilege principle
- **Reverse Proxy:** Enable rate limiting, fail2ban
- **Updates:** Keep Docker and OS updated regularly

## 📝 Notes

- This is a **critical node** - keep it stable and backed up
- Consider redundant runner on Pi3 for failover (future)
- Monitor disk space (Gitea repos can grow)

---

**See also:** [`../README.md`](../README.md) for general server management guide.

